//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Genesis
//                   Product / Project        : Rights Management System
//                   Module                   : Transaction Server
//                   File Name                : WFRMSUtil.java
//                   Author                   : Kahkeshan	
//                   Date written (DD/MM/YYYY): 20/10/2013
//                   Description              : Implements Utility methods used in WAPI Calls

//----------------------------------------------------------------------------------------------------
// Date                         Change By        Change Description (Bug No. (If Any))
//27/11/2013					Sajid Khan			Role Association with RMS.
//05/02/2014					Mohnish Chopra		Added new method to return objects for an Object type
//													on which user have rights along with right string 
//20-03-2014					Sajid Khan			Bug 43147 - Inconsistency in getting process; list for admin user
//27-03-2014                    Kanika Manik        Bug 43147 - Inconsistency in getting process; list for admin user
//14-08-2015					RishiRam Meel       Bug 56027 JBoss EAP : SQL : Functional >> ORM Server logs are not generating on Application server.
//13/05/2016					Mohnish Chopra		Changes for postgres in returnRightsXMLForObjectType
//18/01/2018					Ambuj Tripathi		QA Showstopper bug resolved for WAS+ORacle
//01/05/2019					Ambuj Tripathi		Bug 84414 - Some tables are not getting displayed even if rights have been provided. 
//24/01/2020					Ambuj Tripathi		Bug 90235 - Requirement for the provision of rest APIs for Groups/Profile/User movement in ibps 4.0
//27/01/2020					Ambuj Tripathi		Rights Migration changes for getting the Upated ObjectTypeID from Prod env instead of old objtypeid coming from UAT
//17/04/2020					Ambuj Tripathi		Bug 91296 - Table not visible in Table list when created from a normal User
//14/05/2020					Ravi Ranjan Kumar	Bug 92380 - Right Migration : Need to move Group ,Profile and their Rights and queue Association from source to destination environment for specific process
//21/06/2020					Mohnish Chopra		Internal Bug- Right string from users and group should be calculated using or-ing instead of and-ing.
//01/04/2021                    Sourabh Tantuway    Bug 98954 - iBPS 4.0 : When user logs in Omniapp. There is an error in Report Designer component
//11/05/2021                    Sourabh Tantuway    Bug 99245 - iBPS 4.0 + Oracle : Error coming in Report component  of Omniapp
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.util;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;

import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation.Builder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.glassfish.jersey.client.ClientProperties;
import org.glassfish.jersey.client.JerseyClient;
import org.glassfish.jersey.client.JerseyClientBuilder;

import com.newgen.commonlogger.NGUtil;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFAdminLogValue;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.security.EncodeImage;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.jts.txn.wapi.WFParticipant;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.util.xml.api.CreateXML;

/**
 *
 * @author baby.kahkeshan
 */
public class WFRMSUtil {
    
    private static WFConfigLocator configLocator;
    private static Map<Integer, String[]> objectTypeDetailsMap = new HashMap<Integer, String[]>();

    static {
         Hashtable hCabinetList = ServerProperty.getReference().getCabinetList();
         configLocator = WFConfigLocator.getInstance();
         
    
    }
    
    public static WFParticipant WFCheckSession(Connection con, int sessionId) throws SQLException {
        WFParticipant wfPt = null;
        PreparedStatement pstmt = null;
	PreparedStatement pstmt1 = null;
        ResultSet rs = null;
	ResultSet rs1 = null;
	boolean isExist = false;
	String queryStr = null;		
	String databaseType = null;
	String tableLockStr = null;
        try {
			java.sql.DatabaseMetaData dbMetaData = con.getMetaData();
			databaseType = dbMetaData.getDatabaseProductName();
			if(databaseType.contains("Microsoft")){
				tableLockStr = " WITH (NOLOCK) ";
			} else {
				tableLockStr = "";
			}			
			queryStr = "Select UserID ,  null as UserName , 'U' as ParticipantType , Scope, Locale from " + " WFSessionView " + tableLockStr + " where SessionID = ?";				
			pstmt = con.prepareStatement(queryStr);						
            pstmt.setInt(1, sessionId);            
            pstmt.execute();
            rs = pstmt.getResultSet();						
			if (rs.next()) {
				isExist = true;
			} else {
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				queryStr = "Select PSID as UserId  , " + " PSName as UserName , Type as ParticipantType , 'ADMIN' as Scope, null as Locale from PSRegisterationTable  " + tableLockStr + " where SessionID = ? ";
				pstmt = con.prepareStatement(queryStr);						
				pstmt.setInt(1, sessionId);            
				pstmt.execute();
				rs = pstmt.getResultSet();
				if (rs.next()) {
					isExist = true;
				} 	
			}
			
            /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */			
            if (isExist) {
				int userIndex = rs.getInt(1);
				String userName = rs.getString(2);
				char participantType = rs.getString(3).charAt(0);
				String scope = rs.getString(4);
				String locale = rs.getString("Locale");				
				if(participantType == 'U'){										
					pstmt1 = con.prepareStatement("Select UserName from PDBUser where UserIndex = ?");
					pstmt1.setInt(1, userIndex);
					pstmt1.execute();
					rs1 = pstmt1.getResultSet();
					if (rs1.next()) {
						userName = rs1.getString(1);						
					}										
					if(rs1 != null){
						rs1.close();
						rs1 = null;
					}
					if(pstmt1 != null){
						pstmt1.close();
						pstmt1 = null;
					}										
				}                
				wfPt = new WFParticipant(userIndex, userName, participantType,
                        scope, locale);
						
            }		
			
            if (rs != null) {	//Bugzilla Bug 368

                rs.close();
                rs = null;
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ee) {
            }
			try {                
				if(rs1 != null){
					rs1.close();
					rs1 = null;
				}
            } catch (Exception ee) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ee) {
            }
			try {                
				if(pstmt1 != null){
					pstmt1.close();
					pstmt1 = null;
				}									
            } catch (Exception ee) {
            }
        }
        return wfPt;
    }
	
	//----------------------------------------------------------------------------------------------------
//	Function Name 			:	DB_SetString
//	Date Written (DD/MM/YYYY):	23/10/2013
//	Author					:	Kahkeshan
//	Input Parameters		:	Pos,value,pstmt,dbType
//	Output Parameters		:   none
//	Return Values			:	none
//	Description				:   Set string for prepared statement depending on datatype.
//----------------------------------------------------------------------------------------------------

    public static void DB_SetString(int pos, String value, PreparedStatement pstmt, int dbType) throws SQLException {

        if (dbType == JTSConstant.JTS_ORACLE) {
            if (value == null || value.equals("")) {
                pstmt.setNull(pos, java.sql.Types.CHAR);
            } else {
                //Ashish modified for added for Jboss
                if (pstmt instanceof oracle.jdbc.OraclePreparedStatement) {
                  ((oracle.jdbc.OraclePreparedStatement) pstmt).setFormOfUse(pos, oracle.jdbc.driver.OraclePreparedStatement.FORM_NCHAR);
                //} else if (pstmt instanceof org.jboss.resource.adapter.jdbc.WrappedPreparedStatement) {	//Bugzilla Bug 267
                } else if (pstmt.getClass().getName().equals("org.jboss.resorce.adapter.jdbc.WrappedPreparedStatement")) {	//Bugzilla Bug 267

               ((oracle.jdbc.OraclePreparedStatement) ((org.jboss.resource.adapter.jdbc.WrappedPreparedStatement) pstmt).getUnderlyingStatement()).setFormOfUse(pos, oracle.jdbc.driver.OraclePreparedStatement.FORM_NCHAR);
                }
                pstmt.setString(pos, value);
            }
        } else {
            if (value == null || value.equals("")) {
                pstmt.setNull(pos, java.sql.Types.CHAR);
            } else {
                pstmt.setString(pos, value);
            }
        }
    }

	
	 /**
     * *************************************************************
     * Function Name    :   nextVal
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   Connection, Sequence name, datatbase type
     * Output Parameters:   NONE
     * Return Value     :   String value having next value for the defined sequence
     * Description      :   To get the next value for a given sequence name
     * *************************************************************
     */
    public static String nextVal(Connection con, String sequenceName, int dbType) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        String sqlQuery = "";
        String nextValue = "";

        switch (dbType) {
            case JTSConstant.JTS_ORACLE: {
                sqlQuery = "SELECT " + TO_SANITIZE_STRING(sequenceName,false) + ".NextVal From Dual";
                break;
            }
            case JTSConstant.JTS_POSTGRES: {
                sqlQuery = "SELECT NextVal('" + TO_SANITIZE_STRING(sequenceName,false) + "')";
                break;
            }
            case JTSConstant.JTS_DB2: {
                sqlQuery = "SELECT NextVal for " + TO_SANITIZE_STRING(sequenceName,false) + " from sysibm.sysdummy1";
                break;
            }
        }

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(TO_SANITIZE_STRING(sqlQuery,true));
            if (rs != null && rs.next()) {
                nextValue = TO_SANITIZE_STRING(rs.getString(1),false);
                rs.close();
            }
            rs = null;

            stmt.close();
            stmt = null;

        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ignored) {
            }
            if (stmt != null) {
                try {
                    stmt.close();
                    stmt = null;
                } catch (Exception ignored) {
                }
            }
        }
        return nextValue;
    }
	
	//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getDate
//	Date Written (DD/MM/YYYY)	:	23/10/2013
//	Author						:	Kahkeshan
//	Input Parameters			:	database type
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   returns appropriate current Date String
//----------------------------------------------------------------------------------------------------
    public static String getDate(int dbType) {
        String dateStr = " getDate() ";
        switch (dbType) {
            case JTSConstant.JTS_MSSQL:
                dateStr = " getDate() ";
                break;
            case JTSConstant.JTS_ORACLE:
                dateStr = " sysdate ";
                break;
            case JTSConstant.JTS_POSTGRES:
                dateStr = " CURRENT_TIMESTAMP ";
                break;
            case JTSConstant.JTS_DB2:
                dateStr = " CURRENT TIMESTAMP ";
                break;
            default:
                dateStr = "	getDate() ";
                break;
        }
        return dateStr;
    }

	/**
     * *************************************************************
     * Function Name    :   printQuery
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   Object -> message ,long -> startTime, long ->endTime, 
	                        String -> ProcessInstanceId,int SessionId ,String ->query,String -> engineName
     * Output Parameters:   NONE
     * Return Value     :   ResultSet
     * Description      :   Cabinet based logging To print queries in Query.log
     * *************************************************************
     */


public static ResultSet jdbcExecuteQuery(String ProcessInstanceId,int sessionId,int userId,String query,PreparedStatement pstmt,ArrayList parameters,Boolean flag,String engineName) throws SQLException{
		
		if(flag){
			StringBuffer message = new StringBuffer();
			long startTime = System.currentTimeMillis(); 
			ResultSet res = pstmt.executeQuery();
			long endTime = System.currentTimeMillis(); 
			if(sessionId != 0){
				message.append(" SessionID: ");
				message.append(sessionId);
				message.append(" UserID: ");
				message.append(userId);
			}
			if(ProcessInstanceId != null){
				message.append(" ProcessInstanceId: ");
				message.append(ProcessInstanceId);
			}
			message.append(" StartTime: ");
			message.append(startTime);
			message.append(" EndTime: ");
			message.append(endTime);
			message.append(" Difference: ");	
			message.append(endTime - startTime);
			message.append("\n Query: ");
			message.append(query);
			message.append("\n Parameters :\n index\tvalues\n");
			if(parameters != null){
				for(int i=0;i<parameters.size();i++){
					String val = parameters.get(i).toString();
					message.append(" "+(i+1)+"\t\t"+val+"\n");
				}
				
			}
			return res;
		}
		return null;
	}
public static boolean jdbcExecute(String ProcessInstanceId,int sessionId,int userId,String query,PreparedStatement pstmt,ArrayList parameters,Boolean flag,String engineName) throws SQLException{
		//printOut("printquery with 8 args");
		Boolean res = false;
		if(flag){
			StringBuffer message = new StringBuffer();
			long startTime = System.currentTimeMillis(); 
			res = pstmt.execute();
			long endTime = System.currentTimeMillis(); 
			if(sessionId != 0){
				message.append(" SessionID: ");
				message.append(sessionId);
				message.append(" UserID: ");
				message.append(userId);
			}
			if(ProcessInstanceId != null){
				message.append(" ProcessInstanceId: ");
				message.append(ProcessInstanceId);
			}
			message.append(" StartTime: ");
			message.append(startTime);
			message.append(" EndTime: ");
			message.append(endTime);
			message.append(" Difference: ");	
			message.append(endTime - startTime);
			message.append("\n Query: ");
			message.append(query);
			message.append("\n Parameters :\n index\tvalues\n");
			if(parameters != null){
				for(int i=0;i<parameters.size();i++){
					String val = parameters.get(i).toString();
					message.append(" "+(i+1)+"\t\t"+val+"\n");
				}
				
			}
		}
		return res;
	}
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	TO_DATE
//	Date Written (DD/MM/YYYY)	:	23/10/2013
//	Author						:	Kahkeshan
//	Input Parameters			:	String in , boolean isConst, int dbType
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   returns the SQL Date representation of the given value on the basis of the Database Type
//----------------------------------------------------------------------------------------------------
    public static String TO_DATE(String in, boolean isConst, int dbType) throws WFSException{
        StringBuffer outputXml = new StringBuffer(100);
		String tempDate = null;
        if (in == null || in.equals("")) {
            outputXml.append(" NULL ");
        } else {
			/*Check if date is valid using reg ex*/
			tempDate = (in.indexOf(".") > 0 ? in.substring(0, in.indexOf(".")) : in);
			if (!checkSQLInjectionInDate(tempDate, isConst)) {
				int mainCode = WFSError.WF_OPERATION_FAILED;
				int subCode = WFSError.WFS_ILP;	//Invalid parameter
				String subject = WFSErrorMsg.getMessage(mainCode);
				String errType = WFSError.WF_TMP;
				String descr = WFSErrorMsg.getMessage(subCode);
					throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
            switch (dbType) {
                case JTSConstant.JTS_MSSQL: {
                    outputXml.append("CONVERT( DateTime , ");
                    if (isConst) {
                        outputXml.append("'");
                    }
                    outputXml.append(in);
                    if (isConst) {
                        outputXml.append("'");
                    }
                    outputXml.append(") ");
                    break;
                }
                case JTSConstant.JTS_ORACLE: {
                    outputXml.append(" TO_DATE( ");
                    if (isConst) {
                        outputXml.append("'");
                        outputXml.append(tempDate);
                        outputXml.append("'");
                    } else {
                        outputXml.append(in);
                    }
                    outputXml.append("," + WFSConstant.WF_DATEFMT + ") ");
                    break;
                }
                case JTSConstant.JTS_POSTGRES: {
                    outputXml.append("CAST( ");
                    if (isConst) {
                        outputXml.append("'");
                    }
                    outputXml.append(in);
                    if (isConst) {
                        outputXml.append("'");
                    }
                    outputXml.append(" AS TIMESTAMP) ");
                    break;
                }
                case JTSConstant.JTS_DB2: {					// Coded for DB2 - Virochan

                    outputXml.append("TIMESTAMP_FORMAT(");
                    if (isConst) {
                        /** Bugzilla Id 119, Constant handled differently
                         * 29/08/2006 - Ruhi Hira */
                        outputXml.append("'");
                        in = in.trim();
                        if (in.length() <= 10) {
                            outputXml.append(in);
                            outputXml.append(" 00:00:00");
                        } else if (in.length() <= 19) {
                            outputXml.append(in);
                        } else {
                            /** Bugzilla Id 75, DB2 function does not support nano second part
                             * 21/08/2006 - Ruhi Hira
                             * */
                            outputXml.append(in.substring(0, 19));
                        }
                        outputXml.append("'");
                    } else {
                        outputXml.append(in);
                    }
                    outputXml.append("," + WFSConstant.WF_DATEFMT + ") ");
                    break;
                }
            }
        }
        return outputXml.toString();
    }
    /**
	 * *************************************************************
	 * Function Name    : checkSQLInjectionInDate
	 * Author			: Kahkeshan
	 * Date Written     : 23/10/2013
	 * Input Parameters : String
	 * Output Parameters: NONE
	 * Return Value     : String -> true is valid date pattern 
	 * Description      : to avoid SQL INjection in date type field 
	 * *************************************************************
	 */
	public static boolean checkSQLInjectionInDate(String in, boolean isConst){
		in = in.trim();
		Matcher m = null;
		if (isConst) {
			m = WFSConstant.WF_DATE_PATTERN.matcher(in);
		} else {
			m = WFSConstant.WF_DATE_PATTERN1.matcher(in);
			in = in.substring(1);	//remove ' from the 1st index for SimpleDateFormatting
		}
			
		boolean testMatch = m.matches();
		if (!testMatch) {
			return false;
		} else {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			sdf.setLenient(false);
			try {
				java.util.Date testDate = sdf.parse(in);
			} catch (ParseException ex) {
				return false;
			}
	   }
	   return testMatch;
	}
      //----------------------------------------------------------------------------------------------------
//	Function Name 				:	TO_STRING
//	Date Written (DD/MM/YYYY)	:	23/10/2013
//	Author						:	Kahkeshan
//	Input Parameters			:	String in , boolean isConst, int dbType
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   returns the SQL representation of the given value on the basis of the Database Type
//----------------------------------------------------------------------------------------------------
    public static String TO_STRING(String in, boolean isConst, int dbType) {
        StringBuffer outputXml = new StringBuffer(100);
        if (in == null || in.equals("")) {
            outputXml.append(" NULL ");
        } else {
            switch (dbType) {
                case JTSConstant.JTS_MSSQL: {
                    /** Bugzilla Bug 1241, 1242, Refer ReAssign not working in MSSQL 2005 + Japanese N'XXX's MyQueue'
                     * does not work in MSSQL2005 (other than English, case reported for Japanese) - Ruhi Hira */
                    /** Bugzilla Bug 1705, startsWith, endsWith removed. - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' + char(39) + '"));
                        outputXml.append("'");
                    } else {
                        outputXml.append(in);
                    }
                    break;
                }
                case JTSConstant.JTS_ORACLE: {
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(in);
                        outputXml.append(") )");
                    }
                    break;
                }
                case JTSConstant.JTS_POSTGRES: {
                    if (isConst) {
                        //outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append("'");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    //outputXml.append(" :: VARCHAR ");
                    } else {
                        outputXml.append("UPPER(");
                        outputXml.append(in);
                        outputXml.append(")");
                    }
                    break;
                }
                case JTSConstant.JTS_DB2: {
                    /** Bugzilla Id 68, Aug 16th 2006, N'XXX's MyQueue' does not work - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' || chr(39) || '"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(in);
                        outputXml.append(") )");
                    }
                    break;
                }
            }
        }
        return outputXml.toString();
    }
  //----------------------------------------------------------------------------------------------------
//	Function Name 				:	replace
//	Date Written (DD/MM/YYYY)	:	23/10/2013
//	Author						:	Kahkeshan
//	Input Parameters			:	XMLParser
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   replaces a character by String
//----------------------------------------------------------------------------------------------------
    public static String replace(String in, String src, String dest) {
        // Bug # WFS_6_009, causing NullPointerException if input is null....
        if (in == null || src == null) {
            return in;
        }
        int offset = 0;
        int startindex = 0;
        int srcLen = src.length();
        StringBuffer strBuf = new StringBuffer();
        do {
            try {
                startindex = in.indexOf(src, offset);
                strBuf.append(in.substring(offset, startindex));
                strBuf.append(dest);
                offset = startindex + srcLen;
            } catch (StringIndexOutOfBoundsException e) {
                break;
            }
        } while (startindex >= 0);
        strBuf.append(in.substring(offset));
        return strBuf.toString();
    }
      //----------------------------------------------------------------------------------------------------
//	Function Name 					:	genAdminLogExt
//	Date Written (DD/MM/YYYY)		:	23/10/2013
//	Author							:	Kahkeshan
//	Input Parameters				:	ArrayList value
//	Output Parameters				:   none
//	Return Values					:	void
//	Description						:   Insert data in WFAdminLogTable for logging
//----------------------------------------------------------------------------------------------------
	//Auditing optimized
    public static void genAdminLogExt(Connection con, String engineName, ArrayList values){
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//ArrayList values = new ArrayList();
		int dbType = ServerProperty.getReference().getDBType(engineName);
		java.sql.Date tempDate = null;
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
		try{
			String prop1 = null;
			WFAdminLogValue wfAdminLogValue = null;
			pstmt = con.prepareStatement("Insert into WFAdminLogTable (ActionId, ActionDateTime, ProcessDefId, QueueId , QueueName," +
					" FieldId1, FieldName1, FieldId2, FieldName2, Property, UserId, UserName, OldValue, NewValue, WEFDate," +
					" ValidTillDate, Operation, ProfileId, ProfileName, Property1) Values (?, " + getDate(dbType) + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");// Bug 37345 - Audit trail Issue.

			for (int counter = 0; counter < values.size(); counter++) {
				wfAdminLogValue = (WFAdminLogValue) values.get(counter);
				pstmt.setInt(1, wfAdminLogValue.getActionId());
				pstmt.setInt(2, wfAdminLogValue.getProcDefId());
				pstmt.setInt(3, wfAdminLogValue.getQueueId());
				WFRMSUtil.DB_SetString(4, wfAdminLogValue.getQueueName(), pstmt, dbType);
				pstmt.setInt(5, wfAdminLogValue.getFieldId1());
				WFRMSUtil.DB_SetString(6, wfAdminLogValue.getFieldName1(), pstmt, dbType);
				//if(fieldId2 == 0)
				//fieldId2 = wfAdminLogValue.fieldId2;
				pstmt.setInt(7, wfAdminLogValue.getFieldId2());
				WFRMSUtil.DB_SetString(8, wfAdminLogValue.getFieldName2(), pstmt, dbType);
				WFRMSUtil.DB_SetString(9, wfAdminLogValue.getProperty(), pstmt, dbType);
				pstmt.setInt(10, wfAdminLogValue.getUserId());
				WFRMSUtil.DB_SetString(11, wfAdminLogValue.getUserName(), pstmt, dbType);
				WFRMSUtil.DB_SetString(12, wfAdminLogValue.getOldValue(), pstmt, dbType);
				WFRMSUtil.DB_SetString(13, wfAdminLogValue.getNewValue(), pstmt, dbType);
				if (wfAdminLogValue.getWefDate() == null) {
					pstmt.setDate(14, null);
				}else{                  
					//Bug 38026 - No History generated for operation 'Set Diversion' 
					tempDate = new java.sql.Date(formatter.parse(wfAdminLogValue.getWefDate()).getTime());
					pstmt.setDate(14, tempDate);
				}
				if (wfAdminLogValue.getValidTillDate() == null) {
					pstmt.setDate(15, null);
				}else{
					//Bug 38026 - No History generated for operation 'Set Diversion' 
					tempDate = new java.sql.Date(formatter.parse(wfAdminLogValue.getWefDate()).getTime());
					pstmt.setDate(15, tempDate);
				}
				WFRMSUtil.DB_SetString(16, wfAdminLogValue.getOperation(), pstmt, dbType);//  27/12/2012	Sajid Khan		Bug 37345 - Audit trail Issue.
			  
				pstmt.setInt(17, wfAdminLogValue.getProfileId());
				WFRMSUtil.DB_SetString(18, wfAdminLogValue.getProfileName(), pstmt, dbType);
				prop1 = wfAdminLogValue.getProperty1();
				WFSUtil.printOut(engineName,"Property1::"+prop1);
				WFRMSUtil.DB_SetString(19, prop1, pstmt, dbType);
				
				pstmt.execute();
			}
			pstmt.close();
			pstmt = null;
		}catch (Exception e) {
			WFSUtil.printErr(engineName,"", e);
		}finally{
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception ignored) {
			}
		}
	}
	
	
    /**
     * *************************************************************
     * Function Name    :   getFetchPrefixStr
     * Programmer' Name :   Kahkeshan
     * Date Written     :   23 -oct - 2013
     * Input Parameters :   int -> dbType
     *                      int -> no of records
     * Output Parameters:   NONE
     * Return Value     :   String -> prefix string for database lock
     * Description      :   Query prefix string for fetching limited
     *                      rows from Database
     * *************************************************************
     */
	public static String getFetchPrefixStr(int dbType, int n) {
        String prefixStr = null;
        switch (dbType) {
            case JTSConstant.JTS_MSSQL:
                prefixStr = " Top " + n + " ";
                break;
            case JTSConstant.JTS_ORACLE:
            case JTSConstant.JTS_DB2:
            case JTSConstant.JTS_POSTGRES:
            default:
                prefixStr = " ";
        }
        return prefixStr;
    }
	
	/**
     * *************************************************************
     * Function Name    :   getFetchSuffixStr
     * Programmer' Name :   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   int -> dbType
     *                      int -> no of records
     *                      String -> to be appended before string
     *                      just like AND/ WHERE
     * Output Parameters:   NONE
     * Return Value     :   String -> suffix string for database lock
     * Description      :   Query suffix string for fetching limited
     *                      rows from Database
     * *************************************************************
     */
        public static String getFetchSuffixStr(int dbType, int n, String conditionStr) {
        String suffixStr = null;
        switch (dbType) {
            case JTSConstant.JTS_DB2:
                suffixStr = " fetch first " + n + " rows only ";
                break;
            case JTSConstant.JTS_POSTGRES:
                suffixStr = " LIMIT " + n + " ";
                break;
            case JTSConstant.JTS_ORACLE:
                suffixStr = conditionStr + " ROWNUM <= " + n + " ";
                break;
            case JTSConstant.JTS_MSSQL:
            default:
                suffixStr = "";
        }
        return suffixStr;
    }
	
		
	/**
     * *************************************************************
     * Function Name    :   getAssignableRightsForAnObject
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int objectTypeId
     * Output Parameters:   String
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */
    public static String getAssignableRightsForAnObject(Connection con, int objectTypeId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement pstmt= null;
        StringBuffer strBuff = new StringBuffer(500);
        try {
			pstmt = con.prepareStatement("select RightFlag, RightName from WFAssignableRightsTable where ObjectTypeId = ?");
			pstmt.setInt(1, objectTypeId);
			rs = pstmt.executeQuery();
			strBuff.append("<AssignableRights>");
			while(rs.next()){
				strBuff.append("<AssignableRight>"); 
				strBuff.append("<RightFlag>" + rs.getString("RightFlag") + "</RightFlag>");
				strBuff.append("<RightName>" + rs.getString("RightName") + "</RightName>");
				strBuff.append("</AssignableRight>");
			}
			strBuff.append("</AssignableRights>");
		} finally {
			try{
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
			}catch(Exception e){
				
			}
			try{
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
			}catch(Exception e){
				
			}
        }
		return strBuff.toString();
	}
    public static String getFilter(Connection con, int objTypeId) throws SQLException{
		PreparedStatement pstmt = null;
		CallableStatement cstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String rights = null;
		StringBuffer tempXML = new StringBuffer(200);
		try{		
			pstmt = con.prepareStatement("Select TagName,FilterName from WFFilterListTable  where ObjectTypeId = ?");
			pstmt.setInt(1, objTypeId);
			rs = pstmt.executeQuery();
			tempXML.append("<Filters>");
			while(rs.next()){
				tempXML.append("<Filter>");					
				tempXML.append("<TagName>" + rs.getString("TagName") + "</TagName>");
				tempXML.append("<FilterName>" + rs.getString("FilterName") + "</FilterName>");
				tempXML.append("</Filter>");
			}
			tempXML.append("</Filters>");
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
		return tempXML.toString();
	}
	
	
    /**
     * *************************************************************
     * Function Name    :   getNVARCHARType
     * Programmer' Name :   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   int -> dbType
     * Output Parameters:   NONE
     * Return Value     :   String -> NVarchar type.
     * Description      :   NVarchar type specific to database.
     * *************************************************************
     */
        public static String getNVARCHARType(int dbType) {
        String varcharType = null;
        switch (dbType) {
            case JTSConstant.JTS_MSSQL:
                varcharType = " NVARCHAR ";
                break;
            case JTSConstant.JTS_ORACLE:
                varcharType = " NVARCHAR2 ";
                break;
            case JTSConstant.JTS_DB2:
                varcharType = " VARGRAPHIC ";
                break;
            case JTSConstant.JTS_POSTGRES:
                varcharType = " VARCHAR ";
                break;
            default:
        }
        return varcharType;
    }
	
	/**
     * *************************************************************
     * Function Name    :   executeGetQueryParam
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int objectTypeId
     * Output Parameters:   String[]
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */
	
    public static String[] executeGetQueryParam(Connection con, int objectTypeId) throws SQLException, Exception{
        //System.out.println("within executeGetObjectList ");
        String outputXml = null;
		Statement stmt = null;
		stmt = con.createStatement();
        ResultSet rs = null;
        String className = null;
        String[] queryParam = new String[20];
        rs = stmt.executeQuery("select classname from WFObjectListTable  where ObjectTypeId = "+objectTypeId);
        if(rs.next())
            className = rs.getString(1);
			
		if(stmt != null){
			stmt.close();
			stmt = null;
		}
		if(rs != null){
			rs.close();
			rs = null;
		}
		if(className!=null && !className.isEmpty()){
			try{
		        Class clazz = Class.forName(className);
		        Method method = clazz.getMethod("getQueryParameters", (Class[]) null);
		        queryParam = (String[])method.invoke(clazz.newInstance(), (Object[]) null);
			}catch(Exception ex){
				printErr("", ex.getMessage());
			}
    	}
        //System.out.println("within executeGetObjectList :: output :: " + outputXml);
        return queryParam;
    }
   
/**
     * *************************************************************
     * Function Name    :   executeGetQueryParam
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int objectTypeId
     * Output Parameters:   String[]
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */
   public static String[] executeGetQueryParam(Connection con, int dbType, String objectType) throws SQLException, Exception{
       // printOut("within executeGetObjectList ");
        String outputXml = null;
		Statement stmt = null;
		stmt = con.createStatement();
        ResultSet rs = null;
        String className = null;
        String[] queryParam = new String[20];
        
        rs = stmt.executeQuery("select classname from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = "+TO_STRING(objectType,true,dbType)+"");
        if(rs.next())
            className = rs.getString(1);
		//printOut("className::"+className);
		if(stmt != null){
			stmt.close();
			stmt = null;
		}
		if(rs != null){
			rs.close();
			rs = null;
		}

		if(className!=null && !className.isEmpty()){
			try{
				Class clazz = Class.forName(className);
				Method method = clazz.getMethod("getQueryParameters", (Class[]) null);
				queryParam = (String[])method.invoke(clazz.newInstance(), (Object[]) null);
			}catch(Exception ex){
				printErr("", ex.getMessage());
			}
		}
        //System.out.println("within executeGetObjectList :: output :: " + outputXml);
		//printOut("within queryParam :: " + queryParam[0]+""+queryParam[1]+""+queryParam[2]);
        return queryParam;
    }
	
	   /**
     * *************************************************************
     * Function Name    :   getAssignedRightOnObjType
     * Programmer' Name :   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int objectTypeId, int userid, int assocType
     * Description      :   Give Assigned Rights of a user on ObjectType
     * *************************************************************
     */
    public static String getAssignedRightOnObjType(Connection con, int objectTypeId, int userid, int assocType) throws SQLException{
		StringBuffer strBuff = new StringBuffer(500);
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String rights = null;
		int objectId = 0;
		try{
			pstmt = con.prepareStatement("Select ObjectType, DefaultRight from WFObjectListTable  where ObjectTypeId = ?");
			pstmt.setInt(1, objectTypeId);
			
			rs = pstmt.executeQuery();
			String defaultRights = null;
			String objectType = null;
			if(rs.next()){
				objectType = rs.getString("ObjectType");
				defaultRights = rs.getString("DefaultRight");
			}
			
			//pstmt = con.prepareStatement("select distinct rightstring, filter from WFProfileObjTypeTable A,WFUserObjAssocTable C where A.objecttypeid = C.objecttypeid and C.objecttypeid = ? and C.associationtype = A.associationtype and C.associationtype = ? and C.UserId = A.userid and C.userid = ? ");
			if(assocType==2){
			pstmt = con.prepareStatement("select rightstring, filter from WFProfileObjTypeTable  where ProfileId != 0 and objecttypeid = ? and Associationtype = ? and Userid = ? ");
			pstmt.setInt(1, objectTypeId);
			pstmt.setInt(2, assocType);
			pstmt.setInt(3, userid);
			
			rs = pstmt.executeQuery();
			String filter = null;
			if(rs.next()){
				//found = true;
				rights = rs.getString(1);
				filter = rs.getString("Filter");
			}
			else 
				rights = defaultRights;
			
			strBuff.append("<RightString>" + rights + "</RightString>");
			/*Bug 37094 fixed, null check is inserted */
			if(filter != null && !filter.trim().equals(""))
				strBuff.append("<FilterString>" + filter + "</FilterString>");
			//printOut("strBuff::"+strBuff.toString());
			}
			else{
				boolean flagToAddObjectIdListTag = false;
				String[] queryParamArray = null;
				try {
					queryParamArray = WFSUtil.executeGetQueryParam(con, objectTypeId);
				} catch (Exception e) {
					//e.printStackTrace();
					WFRMSUtil.printErr("", "",e);
				}
				String columnName = queryParamArray[0];
				columnName=TO_SANITIZE_STRING(columnName, true);
				String tableName = queryParamArray[1];
				tableName=TO_SANITIZE_STRING(tableName, true);
				String condition = queryParamArray[2];
				condition=TO_SANITIZE_STRING(condition, true);
				boolean isListTypeObj = false;
				
				if(columnName != null && !columnName.trim().isEmpty() && tableName != null && !tableName.trim().isEmpty() && condition != null && !condition.trim().isEmpty()){
					isListTypeObj = true;
					pstmt = con.prepareStatement("select ObjectId, RightString, Filter, " + columnName + " from WFUserObjAssocTable, "+ tableName +"  where profileid=0 and objecttypeid = ? and Associationtype = ? and Userid = ? " + condition);
				}else{
					pstmt = con.prepareStatement("select ObjectId, RightString, Filter from WFUserObjAssocTable where profileid=0 and objecttypeid = ? and Associationtype = ? and Userid = ? ");
				}
				pstmt.setInt(1, objectTypeId);
				pstmt.setInt(2, assocType);
				pstmt.setInt(3, userid);
				
				rs = pstmt.executeQuery();
				String filter = null;
				while(rs.next()){
					//found = true;
					objectId = rs.getInt("ObjectId");
					String objectName = null;
					if(isListTypeObj){
						objectName = rs.getString(columnName);						
					}
					if(objectId==-1){
						rights = rs.getString("RightString");
						filter = rs.getString("Filter");
						strBuff.append("<RightString>" + rights + "</RightString>");
						/*Bug 37094 fixed, null check is inserted */
						if(filter != null && !filter.trim().equals(""))
							strBuff.append("<FilterString>" + filter + "</FilterString>");
						break;
						}
					else if (objectId!=0){
						if(!flagToAddObjectIdListTag){
							strBuff.append("<ObjectIdList>");
							flagToAddObjectIdListTag = true;
						}
						strBuff.append("<Object>");
						strBuff.append("<ObjectId>" + objectId + "</ObjectId>");
						if(isListTypeObj){
							strBuff.append("<ObjectName>" + objectName + "</ObjectName>");
						}
						rights = rs.getString("RightString");
						filter = rs.getString("Filter");

						strBuff.append("<RightString>" + rights + "</RightString>");
						if(filter != null && !filter.trim().equals(""))
							strBuff.append("<FilterString>" + filter + "</FilterString>");
							strBuff.append("</Object>");
						}
					}
					if(flagToAddObjectIdListTag){
						strBuff.append("</ObjectIdList>");
					}
				}
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
                return strBuff.toString();
	}
	/**
     * *************************************************************
     * Function Name    :   checkRights
     * Author			:   Shweta Singhal
     * Date Written     :   30/08/2012
     * Input Parameters :   Connection con, int dbType, String objectType, int objectId, int sessionID, int rightOrderIndex
     * Output Parameters:   boolean
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */
	public static boolean checkRights(Connection con, int dbType, String objectType, int objectId, int sessionID, int rightOrderIndex) throws SQLException, Exception{
		//PreparedStatement pstmt = null;
		//ResultSet rs = null;
		boolean isRight = false;
		try{		
			String objectRightString = getRightsOnObject(con, dbType, objectType, objectId, sessionID);
			//int orderIndex = getOrderIndex(con, dbType, objectType, rightFlag);
			if(objectRightString!=null && objectRightString.charAt(rightOrderIndex-1) == '1'){
				isRight = true;
			}
		}finally{
//			if(rs != null){
//				rs.close();
//				rs = null;
//			}
//			if(pstmt != null){
//				pstmt.close();
//				pstmt = null;
//			}
		}
		return isRight;
	}
	
	public static String bitToString(final BitSet bs){
		 int length = bs.length();
		 final char[] arr = new char[length];
		 for(int i = 0; i < length; i++){
			arr[length-1-i] = bs.get(i) ? '1' : '0';
		 }
		 String s= String.valueOf(arr);
         
         while(length != 100){
             s= "0"+s;
			 length = s.length();
		 }
         return s;
	}

    public static BitSet createBitset(final String input){
		int length = input.length();
		final BitSet bitSet = new BitSet(length);
		for(int i = 0; i < length; i++){
     	// anything that's not a 1 is a zero, per convention
            bitSet.set(i, input.charAt(length - (i + 1)) == '1');
		}
		return bitSet;
	}
	
	 /* * *************************************************************
     * Function Name    :   returnRightsForObjectType
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int dbType, int userId, String objType,String sortOrder, int batchSize, String lastVal
     * Output Parameters:   String
     * Return Value     :   String 
     * Description      :   return right xml of given objectType
     * *************************************************************
     */
		public static String returnRightsForObjectType(Connection con, int dbType, int userId, String objType,String sortOrder, int batchSize, String lastVal) throws SQLException, Exception{
		return returnRightsForObjectType(con, dbType, userId, objType, sortOrder, batchSize, lastVal, null,0);
	}
	
	
	/**
     * *************************************************************
     * Function Name    :   returnRightsForObjectType
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int dbType, int userId, String objType,String sortOrder, int batchSize, String lastVal
     * Output Parameters:   String
     * Return Value     :   String 
     * Description      :   return right xml of given objectType
     * *************************************************************
     */
public static String returnRightsForObjectType(Connection con, int dbType, int userId, String objType,String sortOrder, int batchSize, String lastVal, String filterString,int projectId) throws SQLException, Exception{
  //private static String getRights(Connection con, int dbType, int sessionId, String objType,String sortOrder, int batchSize, String lastVal) throws SQLException{
        ArrayList<HashMap> arrList = new ArrayList<HashMap>();
		/*HashMap<Integer, String> userMap = null;
		HashMap<Integer, String> groupMap = null; 
		HashMap<Integer, String> profileMap = null;
		HashMap<Integer, String> roleMap = null;*/
        HashMap<Integer, String> finalMap = null;
 
        HashMap<Integer, String> hMap = null;
        StringBuffer tempXML = new StringBuffer("");
        CallableStatement cstmt = null;
        ResultSet rs = null;
        ResultSet cursorResultSet = null;
        String tempRightTable = null;
        Statement stmt = null;
        Statement stmtForCursor = null;
        String cursorName = "";
       try{
			int objectId = 0;
			tempRightTable = getTempTableName(con, "TempObjectRightsTable", dbType);
            String[] qParam = executeGetQueryParam(con, dbType, objType); 
            //String[] qParam = {"ProcessName", "ProcessDefTable", " AND ProcessDefId = ObjectId "};
            String typeNVARCHAR = getNVARCHARType(dbType);
			
			//printOut("tempRightTable " + tempRightTable);
			stmt = con.createStatement();
			createTempTable(stmt, tempRightTable, "AssociationType INT, ObjectId INT, ObjectName " + typeNVARCHAR + "(255), RightString " + typeNVARCHAR + "(100) " , dbType); /*Bug 40277*/
            
			if (dbType == JTSConstant.JTS_MSSQL) {
				cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)}");
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)}");
			}else if (dbType == JTSConstant.JTS_POSTGRES) {
                               cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                                con.setAutoCommit(false);
                        }
			cstmt.setInt(1, userId);
            //cstmt.setInt(2, 2);
            cstmt.setString(2, objType);
            cstmt.setString(3, qParam[0]);
            cstmt.setString(4, qParam[1]);
            cstmt.setString(5, qParam[2]);
            cstmt.setString(6, tempRightTable);
            cstmt.setString(7, sortOrder);
            cstmt.setInt(8, batchSize);
            if(lastVal == null || lastVal.equals(""))
                cstmt.setNull(9, java.sql.Types.VARCHAR);
            else
                cstmt.setString(9, lastVal);
			
			if(filterString == null || filterString.equals(""))
                cstmt.setNull(10, java.sql.Types.VARCHAR);
            else
                cstmt.setString(10, filterString);
			
			cstmt.setInt(11, 0);
                        cstmt.setInt(12, projectId);
			if (dbType == JTSConstant.JTS_ORACLE) {				
				cstmt.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
				cstmt.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
			}	

            cstmt.execute();
			if (dbType == JTSConstant.JTS_MSSQL) /* ResultSet 1 -> User' Preferences */ {
				rs = cstmt.getResultSet();
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				rs = (ResultSet) cstmt.getObject(13);
			}else if (dbType == JTSConstant.JTS_POSTGRES ) {
                            cursorResultSet = cstmt.getResultSet();
                            stmtForCursor = con.createStatement();
                            if(cursorResultSet.next()){
                                cursorName = cursorResultSet.getString(1);
                                if(rs!=null){
                                    rs.close();
                                    rs = null;
                                }
                                rs = stmtForCursor.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName,true) + "\"");
                            }
                        }               
			
            int assocType =0;
            finalMap = new HashMap<Integer, String>();

			/*userMap = new HashMap<Integer, String>();
			groupMap = new HashMap<Integer, String>();
			profileMap = new HashMap<Integer, String>();
			roleMap = new HashMap<Integer, String>();*/
            
			while(rs.next()){
                assocType = rs.getInt("AssociationType");
                finalMap.putAll(getRights(rs, finalMap));			

                /*if(assocType == 0){
                    userMap.putAll(getRights(rs, userMap));			
                }else if(assocType == 1){
                    groupMap.putAll(getRights(rs, groupMap));			

                }else if(assocType == 2){
                    profileMap.putAll(getRights(rs, profileMap));			
                }else if(assocType == 3){
                    roleMap.putAll(getRights(rs, roleMap));			
                }*/
                }
            
            if (rs != null) {
                rs.close();
                rs = null;
            }
            arrList.add(0, finalMap);

            /*arrList.add(0, userMap);
            arrList.add(1, groupMap);
            arrList.add(2, profileMap);
            arrList.add(3, roleMap);*/
            tempXML = new StringBuffer(200);
            tempXML.append("<Objects>");
            
            int objId = 0;  
            int retCount = 0;
            int totalCount = 0;
            hMap = new HashMap<Integer, String>();
            if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || (dbType == JTSConstant.JTS_POSTGRES && cursorResultSet.next())) {
                if (dbType == JTSConstant.JTS_ORACLE) {
					rs = (ResultSet) cstmt.getObject(14);
				} else if (dbType == JTSConstant.JTS_MSSQL) {
					rs = cstmt.getResultSet();				
				}else if (dbType == JTSConstant.JTS_POSTGRES ) {
                                    stmtForCursor.close();
                                    stmtForCursor = null;
                                    stmtForCursor = con.createStatement();
                                    cursorName = cursorResultSet.getString(1);
                                    if(rs!=null){
                                        rs.close();
                                        rs = null;
                                    }    
                                    rs = stmtForCursor.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName,true) + "\"");
                                }
                batchSize = batchSize <= 0 ? Integer.MAX_VALUE : batchSize;
                while(retCount < batchSize && rs.next()){                   
                    objId = rs.getInt("ObjectId");
                    if(arrList.get(0).containsKey(objId)){
                        hMap = arrList.get(0);
                        tempXML.append(createTempXML(hMap,objId));
					}/*else if(arrList.get(1).containsKey(objId)){
                        hMap = arrList.get(1);
                        tempXML.append(createTempXML(hMap,objId));
                    }else if(arrList.get(2).containsKey(objId)){
                        hMap = arrList.get(2);
                        tempXML.append(createTempXML(hMap,objId));
                    }else if(arrList.get(3).containsKey(objId)){
                        hMap = arrList.get(3);
                        tempXML.append(createTempXML(hMap,objId));
                    }		*/
                    retCount++;
					totalCount++;
                }
                if(rs.next())
					totalCount++;
				if (rs != null) {
                    rs.close();
					rs = null;
                }
            }
            tempXML.append("</Objects>");
			//tempXML.append(gen.writeValueOf("RetrievedCount", String.valueOf(retCount)));
			//tempXML.append(gen.writeValueOf("TotalCount", String.valueOf(totalCount)));
            tempXML.append("<RetrievedCount>");
            tempXML.append(String.valueOf(retCount));
            tempXML.append("</RetrievedCount>");
            tempXML.append("<TotalCount>");
            tempXML.append(String.valueOf(totalCount));
            tempXML.append("</TotalCount>");
	    if (dbType == JTSConstant.JTS_POSTGRES) {
                con.commit();
                con.setAutoCommit(true);
            }		
            //printOut("tempXML::"+tempXML.toString());
        }finally{
           if(stmt != null){                
				try{
					dropTempTable(stmt, tempRightTable, dbType);
				} catch(Exception excp){}
	        }
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
                                if(cursorResultSet != null){
                                    cursorResultSet.close();
                                    cursorResultSet = null;
				}
                                if(stmtForCursor != null){
                                    stmtForCursor.close();
                                    stmtForCursor = null;
				}
			}catch(Exception ignored){}
            
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
                if(cstmt != null){
					cstmt.close();
					cstmt = null;
				}
			}catch(Exception ignored){}
       }
    return tempXML.toString();
	}
	
	
	/**
     * *************************************************************
     * Function Name    :   getTempTableName(
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :
     * Output Parameters:   NONE
     * Return Value     :   String value having next value for the defined sequence
     * Description      :   To get the next value for a given sequence name
     * *************************************************************
     */
public static String getTempTableName(Connection con, String tableName, int dbType) {
        String newName = null;

        switch (dbType) {
            case JTSConstant.JTS_MSSQL: {
                newName = "#" + tableName;
                break;
            }
            case JTSConstant.JTS_ORACLE: {
                newName = "G" + tableName;
                break;
            }
            case JTSConstant.JTS_DB2: {
                newName = "G" + tableName + "_" + con.hashCode();
                break;
            }
            default: {
                newName = tableName;
                break;
            }
        }
        return newName;
    }
	
	
	 /**
     * *************************************************************
     * Function Name    :   createTempTable
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :
     * Output Parameters:   NONE
     * Return Value     :   String value having next value for the defined sequence
     * Description      :   To get the next value for a given sequence name
     * *************************************************************
     */
 public static void createTempTable(Statement stmt, String tableName, String columnList, int dbType) throws SQLException {
        createTempTable(stmt, tableName, columnList, "", "", dbType);
    }

    public static void createTempTable(Statement stmt, String tableName, String columnList, String indexName, String indexList, int dbType) throws SQLException {
        String sqlQuery = "";
        String indexQuery = "";

        switch (dbType) {
            case JTSConstant.JTS_ORACLE: {
                //We are using global Temporary table
                return;
            }
            case JTSConstant.JTS_POSTGRES: {
                sqlQuery = "CREATE TEMP TABLE " + tableName + "(" + columnList + ")";
                if (indexList != null && !indexList.trim().equalsIgnoreCase("")) {
                    indexQuery = "CREATE INDEX " + indexName + " on " + tableName + " (" + indexList + ")";
                }
                break;
            }
            default: {
                sqlQuery = "CREATE TABLE " + tableName + "(" + columnList + ")";
                if (indexList != null && !indexList.trim().equalsIgnoreCase("")) {
                    indexQuery = "CREATE INDEX " + indexName + " on " + tableName + " (" + indexList + ")";
                }
                break;
            }
        }
        stmt.execute(sqlQuery);

        if (!indexQuery.trim().equalsIgnoreCase("")) {
            stmt.execute(indexQuery);
        }
    }

    public static void dropTempTable(Statement stmt, String tableName, int dbType) throws SQLException {
        String sqlQuery = "";

        switch (dbType) {
            case JTSConstant.JTS_ORACLE: {
                sqlQuery = "Truncate Table " + tableName;	//Bugzilla Bug 3430

                break;
            }
            case JTSConstant.JTS_POSTGRES: {
                sqlQuery = "Drop Table IF EXISTS " + tableName;	//Bugzilla Bug 3430

                break;
            }
            default: {
                sqlQuery = "Drop Table " + tableName;
                break;
            }
        }
        stmt.execute(sqlQuery);
    }
public static String createTempXML(HashMap hMap, int objId){
        StringBuffer tempXML = new StringBuffer(200);
        tempXML.append("<Object>");
		char char21 = 21;
		String string21 = "" + char21;
        //objId = Integer.parseInt(iterator.next().toString());
        tempXML.append("<ObjectId>");
        tempXML.append(String.valueOf(objId));
        tempXML.append("</ObjectId>");
        String value =(String) hMap.get(objId);
        int index = value.indexOf(string21);
        String objName = value.substring(0,index);
		// Change for Bug 39726
		if(objName.indexOf(";&hash") != -1) 
            objName = objName.replace(";&hash", string21);
        String rightString = value.substring(index+1);
        tempXML.append("<ObjectName>");
        tempXML.append(objName);
        tempXML.append("</ObjectName>");
        tempXML.append("<RightString>");
        tempXML.append(rightString);
        tempXML.append("</RightString>");
        tempXML.append("</Object>");
		
		return tempXML.toString();
	}
	
	/**
     * *************************************************************
     * Function Name    :   getRights
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   ResultSet rs, HashMap hMap
     * Output Parameters:   String
     * Return Value     :   HashMap<Integer, String> 
     * Description      :   get Rights For Objects fetched from given resultset
     * *************************************************************
     */
	public static HashMap<Integer, String> getRights(ResultSet rs, HashMap hMap) throws SQLException{
        
		int objectId = rs.getInt("ObjectId");
        String rightString = null;
        String objectName = null;
        String right = null;
		char char21 = 21;
		String string21 = "" + char21;
		if(hMap.get(objectId)==null){
            rightString = rs.getString("RightString");
			objectName = rs.getString("ObjectName");
			// Change for Bug 39726
			if(objectName!= null && objectName.indexOf(string21) != -1)
				objectName = objectName.replace(string21, ";&hash");
			hMap.put(objectId, objectName+string21+rightString);
		}
		else{
            right = (String)hMap.get(objectId);
			right = right.substring(right.indexOf(string21));
			BitSet bs1 = createBitset(right);
			rightString = rs.getString("RightString");
			objectName = rs.getString("ObjectName");
			BitSet bs2 = createBitset(rightString); 
			bs1.or(bs2);
			rightString = bitToString(bs1);
			hMap.put(objectId, objectName+string21+rightString);
		}
		return hMap;
	}


	/**
     * *************************************************************
     * Function Name    :   getRoleList
     * Author			:   Sajid Khan
     * Date Written     :   26/11/2013
     * Input Parameters :   Statement stmt, int profileId, int associationType
     * Output Parameters:   ArrayList
     * Return Value     :   profileList
     * Description      :   Return profileList associated with one User/Group
     * *************************************************************
     */
   
   public static HashMap getRoleList(Statement stmt, int profileId, int associationType) throws SQLException{
		String strQuery = null;
		ResultSet rs = null;
		HashMap roleMap = null;
		char char21 = 21;
		String string21 = "" + char21;
		try{
			roleMap = new HashMap();
			
			rs = stmt.executeQuery("Select UserId, AssignedTillDateTime, AssociationFlag from WFUserObjAssocTable  where ProfileId = " + profileId + " AND AssociationType = " + associationType);
			while(rs.next()){
				roleMap.put(rs.getInt(1),rs.getString(2)+string21+rs.getString(3));
				//printOut("RoleMap>>>>WFSUtil>>getRoleList>>>>"+roleMap);
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
		 }finally{
			if(rs != null){
				rs.close();
				rs = null;
			}
		}

		return roleMap;
	}
	
	/**
     * *************************************************************
     * Function Name    :   getRightsOnObject
     * Author			:   Shweta Singhal
     * Date Written     :   30/08/2012
     * Input Parameters :   Connection con, int dbType, String objectType, int objectId, int sessionID
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   Return Rights on a given ObjectId for a given ObjectType
     * *************************************************************
     */
	public static String getRightsOnObject(Connection con, int dbType, String objectType, int objectId, int sessionID) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rights = null;
		try{
			WFParticipant user = WFCheckSession(con, sessionID);
            int userId = 0;
            /* Bug 38083 fixed, WFSException will be returned in case of user = null*/
            if(user != null)
                userId = user.getid();
            else{   
                int mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                int subCode = 0;
                String subject = WFSErrorMsg.getMessage(mainCode);
                String descr = WFSErrorMsg.getMessage(subCode);
                String errType = WFSError.WF_TMP;
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }    
			String userName = user.getname();
			int noOfRecToFetch = 1;
			String sortOrder = "A";
			String lastValue = "";
			//String filterString = null;
			boolean isRightCheck = false;
			

                pstmt = con.prepareStatement("Select DefaultRight from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = ?");
                pstmt.setString(1, objectType);
                rs = pstmt.executeQuery();
                String defaultString = null;
                if(rs.next()){
                    defaultString = rs.getString("DefaultRight");
                }
                //rights = getRightsOnObject(con, dbType, objectType, objectId, sessionID, defaultString);
                rights = returnRightsForObjectType(con, dbType, userId, objectType, objectId, sortOrder, noOfRecToFetch, lastValue, isRightCheck, defaultString);
			
			StringBuffer logProp= new StringBuffer("UserId::"+userId+" UserName::"+userName+" ObjectId::"+objectId+" ObjectType::"+objectType+" RightString: "+rights);
			
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
		return rights;
	}
	
	  /**
     * *************************************************************
     * Function Name    :   getRightsOnObjectType
     * Programmer' Name :   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int dbType, String objectType, int sessionID
     * Description      :   Give Rights of a user on ObjectType
     * *************************************************************
     */
	public static String getRightsOnObjectType(Connection con, int dbType, String objectType, int sessionID) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rights = null;
		try{
			pstmt = con.prepareStatement("Select DefaultRight from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = ?");
			pstmt.setString(1, objectType);
			rs = pstmt.executeQuery();
			String defaultString = null;
			if(rs.next()){
				defaultString = rs.getString("DefaultRight");
			}
			
			rights = getRightsOnObjectType(con, dbType, objectType, sessionID, defaultString);
			
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
		return rights;
	
	}
	
		/**
     * *************************************************************
     * Function Name    :   getRightsOnObjectType
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   Connection con, int dbType, String objectType, int objectId, int sessionID, String defaultRights
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   Return Rights on a given ObjectId for a given ObjectType
     * *************************************************************
     */
	public static String getRightsOnObjectType(Connection con, int dbType, String objectType, int sessionID, String defaultRights) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> objTypeRightString = new ArrayList<String>();
		String rights = null;
		try{
			WFParticipant user = WFCheckSession(con, sessionID);
			int userId = 0;
            /* Bug 38083 fixed, WFSException will be returned in case of user = null*/
            if(user != null)
                userId = user.getid();
            else{   
                int mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                int subCode = 0;
                String subject = WFSErrorMsg.getMessage(mainCode);
                String descr = WFSErrorMsg.getMessage(subCode);
                String errType = WFSError.WF_TMP;
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }
			String userName = user.getname();
			

                /*Bug 37558 fixed*/
                /*Bug 37625 fixed*/
                pstmt = con.prepareStatement("select distinct RightString from WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " ,WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + "  where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 0 and A.userid = ? ");
                
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                boolean found = false;
                while(rs.next()){
                    objTypeRightString.add(rs.getString("RightString"));
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
                /*Bug 37625 fixed*/
                pstmt = con.prepareStatement("select distinct rightstring from  WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " , WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + " , WFGROUPMEMBERVIEW  C where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 1  and C.groupindex > 0 and C.groupindex= A.userid and C.userindex = ? ");
                
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                while(rs.next()){
                    objTypeRightString.add(rs.getString("RightString"));
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
				
				pstmt = con.prepareStatement("select distinct rightstring from  WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " , WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + " , PDBGroupRoles  C " + WFSUtil.getTableLockHintStr(dbType) + "  where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 3  and C.roleindex > 0 and C.roleindex= A.userid and C.userindex = ? ");
                
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                while(rs.next()){
                    objTypeRightString.add(rs.getString("RightString"));
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
               /* pstmt = con.prepareStatement("select distinct rightstring from WFProfileObjTypeTable A,WFObjectListTable  B, PROFILEUSERGROUPVIEW C where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 2 and C.profileId > 0 and C.profileId = A.userid and C.userid = ? ");*/
				pstmt = con.prepareStatement("select distinct rightstring from WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " ,WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + " , PROFILEUSERGROUPVIEW C where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 2 and C.profileId > 0 and C.profileId = A.userid and C.userid = ? ");
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                while(rs.next()){
                    objTypeRightString.add(rs.getString("RightString"));
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
			   
				pstmt = con.prepareStatement("select distinct rightstring from WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " ,WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + " , PROFILEUSERGROUPVIEW C, WFGROUPMEMBERVIEW  D ,PDBGroupRoles E " + WFSUtil.getTableLockHintStr(dbType) + "  where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 2 and D.groupindex > 0 and C.profileId > 0 and C.profileId = A.UserId and D.groupindex = C.groupid and D.userindex = C.userid and E.roleindex = C.RoleId and D.userindex =  ? ");
                
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                while(rs.next()){
                    objTypeRightString.add(rs.getString("RightString"));
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
                
                pstmt = con.prepareStatement("select distinct rightstring from WFProfileObjTypeTable A " + WFSUtil.getTableLockHintStr(dbType) + " ,WFObjectListTable  B " + WFSUtil.getTableLockHintStr(dbType) + " , PROFILEUSERGROUPVIEW C, WFGROUPMEMBERVIEW  D where A.objecttypeid = B.objecttypeid and B.objecttype = ? and Associationtype = 2 and D.groupindex > 0 and C.profileId > 0 and C.profileId = A.UserId and D.groupindex = C.groupid and D.userindex = C.userid and D.userindex =  ? ");
                
                DB_SetString(1, objectType, pstmt, dbType);
                pstmt.setInt(2,userId);
                rs = pstmt.executeQuery();
                String rightString = null;
                while(rs.next()){
                    rightString = rs.getString("RightString");
                   // printOut("rightString::"+rightString);
                    objTypeRightString.add(rightString);
                    found = true;
                }
                if (rs != null) {
                	rs.close();
                	rs = null;
                }	
                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }	
                int size = objTypeRightString.size();
               // printOut("<GetRightsOnObjectType> size::"+size);
                if(found){
                    BitSet bs1 = createBitset(objTypeRightString.get(0));	
                    for(int j=1; j < size;j++){
                        BitSet bs2 = createBitset(objTypeRightString.get(j)); 
                        bs1.or(bs2);
                    }
                   // printOut("bs1::"+bs1);
                    rights = bitToString(bs1);
                   // printOut("rights::"+rights);
                }else{
                    rights = defaultRights;
                }
                
                //Enhancement 37672 
            StringBuffer logProp= new StringBuffer("UserId::"+userId+" UserName::"+userName+" ObjectType::"+objectType+" RightString: "+rights);
            
			
//			if(rs != null){
//				rs.close();
//				rs = null;
//			}
//			if(pstmt != null){
//				pstmt.close();
//				pstmt = null;
//			}
		}finally{
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}
		}
		return rights;
	}
	
	
		
	/**
     * *************************************************************
     * Function Name    :   returnRightsForObjectType
     * Author			:   Kahkeshan
     * Date Written     :   23 Oct 2013
     * Input Parameters :   Connection con, int dbType, int userId, String objType, int objectId, String sortOrder, int batchSize, String lastVal, boolean isRightCheck, String defaultString
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   Return Rights on a given ObjectId for a given ObjectType
     * *************************************************************
     */
	public static String returnRightsForObjectType(Connection con, int dbType, int userId, String objType, int objectId, String sortOrder, int batchSize, String lastVal, boolean isRightCheck, String defaultString) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		CallableStatement cstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
                ResultSet cursorResultSet = null;
		String rights = null;
		String filterString = null;
		String tempRightTable = null;
		ResultSet tempRs = null;
		ArrayList<String> objTypeRightString = new ArrayList<String>();
                Statement stmtForCursor = null;
                String cursorName = "";
		try{
			if(defaultString==null || defaultString.equals("")){
				pstmt = con.prepareStatement("Select DefaultRight from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = ?");
				pstmt.setString(1, objType);
				rs = pstmt.executeQuery();
				if(rs.next()){
					defaultString = TO_SANITIZE_STRING(rs.getString("DefaultRight"),false);
				}
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}
			tempRightTable = getTempTableName(con, "TempObjectRightsTable", dbType);
			//createTempRightTable(con, dbType);
			String typeNVARCHAR = getNVARCHARType(dbType);
			
			//printOut("tempRightTable " + tempRightTable);
			stmt = con.createStatement();
			createTempTable(stmt, tempRightTable, "AssociationType INT, ObjectId INT, ObjectName " + typeNVARCHAR + "(255), RightString " + typeNVARCHAR + "(100) " , dbType); /*Bug 40277*/
			String[] qParam = executeGetQueryParam(con, dbType, objType); 
			
			if (dbType == JTSConstant.JTS_MSSQL) {
				cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			}else if (dbType == JTSConstant.JTS_POSTGRES) {
                               cstmt = con.prepareCall("{call WFReturnRightsForObjType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                               con.setAutoCommit(false);
                        }
			cstmt.setInt(1, userId);
            //cstmt.setInt(2, 2);
            cstmt.setString(2, objType);
            cstmt.setString(3, qParam[0]);
			cstmt.setString(4, qParam[1]);
            cstmt.setString(5, qParam[2]);
            cstmt.setString(6, tempRightTable);
            cstmt.setString(7, sortOrder);
            cstmt.setInt(8, batchSize);
            if(lastVal == null || lastVal.equals(""))
                cstmt.setNull(9, java.sql.Types.VARCHAR);
            else
                cstmt.setString(9, lastVal);
			if(filterString == null || filterString.equals(""))
                cstmt.setNull(10, java.sql.Types.VARCHAR);
            else
                cstmt.setString(10, filterString);
                cstmt.setInt(11, objectId);
		cstmt.setInt(12, 0);
			if (dbType == JTSConstant.JTS_ORACLE) {				
				cstmt.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
				cstmt.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
			}	
			
			cstmt.execute();
			if (dbType == JTSConstant.JTS_MSSQL) /* ResultSet 1 -> User' Preferences */ {
				rs = cstmt.getResultSet();
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				rs = (ResultSet) cstmt.getObject(13);
				tempRs = (ResultSet)cstmt.getObject(14);				
			}else if (dbType == JTSConstant.JTS_POSTGRES ) {
                            cursorResultSet = cstmt.getResultSet();
                            stmtForCursor = con.createStatement();
                            if(cursorResultSet.next()){
                                cursorName = cursorResultSet.getString(1);
                                if(rs!=null){
                                    rs.close();
                                    rs = null;
                                }
                                rs = stmtForCursor.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName,true) + "\"");
                            }
                        }   
			if(tempRs != null){
				tempRs.close();
				tempRs = null;
			}
			
			boolean found = false;
			String rightString = null;
			while(rs.next()){
				rightString = rs.getString("RightString");
				objTypeRightString.add(rightString);
				//objTypeRightString.add(rs.getString("RightString"));
				found = true;
			}
			
			int size = objTypeRightString.size();
			//printOut("size::"+size);
			if(found){
				BitSet bs1 = createBitset(objTypeRightString.get(0));	
				for(int j=1; j < size;j++){
					BitSet bs2 = createBitset(objTypeRightString.get(j)); 
					bs1.or(bs2);
				}
				//printOut("rights bs1::"+bs1);
				rights = bitToString(bs1);
				//printOut("rights::"+rights);
			}else{
				rights = defaultString;
			}
		}finally{
			if(stmt != null){                
				try{
					if (dbType == JTSConstant.JTS_POSTGRES) {
                        con.commit();
                        con.setAutoCommit(true);
                    }
					dropTempTable(stmt, tempRightTable, dbType);
				} catch(Exception excp){}
	        }
                         if(cursorResultSet != null){
                            cursorResultSet.close();
                            cursorResultSet = null;
                        }
                        if(stmtForCursor != null){
                            stmtForCursor.close();
                            stmtForCursor = null;
                        }
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}				
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
				if(tempRs != null){
					tempRs.close();
					tempRs = null;
				}
				
			}catch(Exception ignored){}
            try{
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
                if(cstmt != null){
					cstmt.close();
					cstmt = null;
				}
			}catch(Exception ignored){}
		}
		
		return rights;
	}
	
	
	/**
     * *************************************************************
     * Function Name    :   getTableLockHintStr
     * Programmer' Name :   Ruhi Hira
     * Date Written     :   October 23 2013
     * Input Parameters :   int -> dbType
     * Output Parameters:   NONE
     * Return Value     :   String -> Returns lock hint string for table.
     * Description      :   NOLOCK for MSSQL
     * *************************************************************
     */
	public static String getTableLockHintStr(int dbType) {
        String lockHintStr = "";
        switch (dbType) {
            case JTSConstant.JTS_MSSQL:
                lockHintStr = " WITH (NOLOCK) ";
                break;
            case JTSConstant.JTS_ORACLE:
            case JTSConstant.JTS_DB2:
            case JTSConstant.JTS_POSTGRES:
            default:
        }
        return lockHintStr;
    }
	
	
	/**
     * *************************************************************
     * Function Name    :   printQuery
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   Object -> message ,long -> startTime, long ->endTime, 
	                        String -> ProcessInstanceId,int SessionId ,String ->query,String -> engineName
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Cabinet based logging To print queries in Query.log
     * *************************************************************
     */
//        public static int jdbcExecuteUpdate(String ProcessInstanceId,int sessionId,int userId,String query,PreparedStatement pstmt,ArrayList parameters,Boolean flag,String engineName) throws SQLException{
//		//printOut("jdbcExecuteUpdate");
//		int res = 0;
//		if(flag){
//			StringBuffer message = new StringBuffer();
//			long startTime = System.currentTimeMillis();
//			res = pstmt.executeUpdate();
//			long endTime = System.currentTimeMillis();
//			if(sessionId != 0){
//				message.append(" SessionID: ");
//				message.append(sessionId);
//				message.append(" UserID: ");
//				message.append(userId);
//			}
//			if(ProcessInstanceId != null){
//				message.append(" ProcessInstanceId: ");
//				message.append(ProcessInstanceId);
//			}
//			message.append(" StartTime: ");
//			message.append(startTime);
//			message.append(" EndTime: ");
//			message.append(endTime);
//			message.append(" Difference: ");
//			message.append(endTime - startTime);
//			message.append("\n Query: ");
//			message.append(query);
//			message.append("\n Parameters :\n index\tvalues\n");
//			if(parameters != null){
//				for(int i=0;i<parameters.size();i++){
//					String val = parameters.get(i).toString();
//					message.append(" "+(i+1)+"\t\t"+val+"\n");
//				}
//
//			}
//		}
//		return res;
//	}
      
	/**
     * *************************************************************
     * Function Name    :   executeGetObjectList
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   Connection con, XMLParser parser, XMLGenerator gen, int objectTypeId
     * Output Parameters:   String
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */
	  public static String executeGetObjectList(Connection con, XMLParser parser, XMLGenerator gen, int objectTypeId) throws SQLException, Exception{
        //System.out.println("within executeGetObjectList ");
        String outputXml = null;
		Statement stmt = null;
		stmt = con.createStatement();
        ResultSet rs = null;
        String className = null;
        rs = stmt.executeQuery("select classname from WFObjectListTable where ObjectTypeId = " + objectTypeId);
        if(rs.next())
            className = rs.getString(1);
			
		if(stmt != null){
			stmt.close();
			stmt = null;
		}
		if(rs != null){
			rs.close();
			rs = null;
		}			
        Class clazz = Class.forName(className);
        Method method = clazz.getMethod("getObjectList", new Class[]{Connection.class, XMLParser.class, XMLGenerator.class});
        outputXml = (String)method.invoke(clazz.newInstance(), new Object[]{con, parser, gen});
        //System.out.println("within executeGetObjectList :: output :: " + outputXml);
        return outputXml;
	}  
          /**
     * *************************************************************
     * Function Name    :   printErr
     * Author			:   Kahkeshan
     * Date Written     :   23 OCt 2013
     * Input Parameters :   Object -> message
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   To print Error messages in Error.log
     * *************************************************************
     */

   public static void printErr(String cabinetName, Object message) {
//		
        NGUtil.writeErrorLog(cabinetName, WFSConstant.CONST_ORM_MODULE, message);
   }
//

    public static void printErr(String cabinetName,Object message, Throwable t) {
//		
		 NGUtil.writeErrorLog(cabinetName, WFSConstant.CONST_ORM_MODULE, message, t);
 }


    


    
	  public static void printOut(String engineName, Object message) {
         /*User/API logging support- sajid khan**/
        /******************************************/
        String strArr[] = WFSUtil.returnUserApiStatus();
        String userApiStatus = strArr[1];

         if(userApiStatus.equals("10")){
             NGUtil.writeUserConsoleLog(engineName, WFSConstant.CONST_ORM_MODULE, message);
         }else if (userApiStatus.equals("01")){
            NGUtil.writeApiConsoleLog(engineName, WFSConstant.CONST_ORM_MODULE, message);
         }else if (userApiStatus.equals("11")){
            NGUtil.writeUserConsoleLog(engineName, WFSConstant.CONST_ORM_MODULE, message);
         }
		
        NGUtil.writeConsoleLog(engineName, WFSConstant.CONST_ORM_MODULE, message);
    }
	

    /**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :   Oct 23 2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in Transaction.log
     * *************************************************************
     */
	public static void writeLog(String clientId, String strOption, long input1, long input2, int state) {
			StringBuffer message = new StringBuffer();
			//message.append("Transaction: ");
			message.append(strOption);
		 //  message.append(" Status: ");
		   if (state == 0 || state == 18) {
			   message.append(" Success");
			} else {
			   message.append(" Failed");
		   }
		 //  message.append(" Client: ");
		  // message.append(clientId);
		 //  message.append(" StartTime: ");
		 //  message.append(input1);
		//	message.append(" EndTime: ");
		//	message.append(input2);
			message.append(" Difference: ");
			message.append(input2 - input1);
			NGUtil.writeTransactionLog("", WFSConstant.CONST_ORM_MODULE, message);
           
			message = null;
	}
	
	/**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :   23 Oct 2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in Transaction.log
     * *************************************************************
     */
	//WFS_8.0_127
   public static void writeLog(String clientId, String strOption, long input1, long input2, int state,String OutputXml) {
       StringBuffer message = new StringBuffer();
      // message.append("Transaction: ");
       message.append(strOption);
      // message.append(" Status: ");
       if (state == 0 || state == 18) {
           message.append(" Success");
       } else {
           message.append(" Failed");
       }
     //  message.append(" Client: ");
     //  message.append(clientId);
      // message.append(" StartTime: ");
     //  message.append(input1);
     //  message.append(" EndTime: ");
      // message.append(input2);
       message.append(" Difference: ");
       message.append(input2 - input1);
       message.append(" Size: ");
       message.append(OutputXml.length());
       
	   NGUtil.writeTransactionLog("", WFSConstant.CONST_ORM_MODULE, message);
       message = null;
   }

   
    /**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in Transaction.log
     * *************************************************************
     */
	//WFS_8.0_127
   public static void writeLog(String clientId, String strOption, long input1, long input2, int state,String OutputXml, String strCabinetName, boolean flag, long connectionTime, int sessionID, int userID) {
       StringBuffer message = new StringBuffer();
      // message.append("Transaction: ");
       message.append(strOption);
       if (state == 0 || state == 18) {
           message.append(" Success ");
       } else {
           message.append(" Failed ");
       }
     //  message.append(" Client: ");
     //  message.append(clientId);  /* Bug 38914 */
		if(sessionID != 0){
			message.append(" SessionID: ");
			message.append(sessionID);
			message.append(" UserID ");
			message.append(userID);
		}
     //  message.append(" StartTime: ");
      // message.append(input1);
     //  message.append(" EndTime: ");
     // message.append(input2);
       message.append(" Difference: ");
       message.append(input2 - input1);
		message.append(" ConnectionTime: ");
		message.append(connectionTime);
       message.append(" Size: ");
       message.append(OutputXml.length());
      
	    NGUtil.writeTransactionLog(strCabinetName, WFSConstant.CONST_ORM_MODULE, message);
       message = null;
   }


	/**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state, String inputXml, String outputXml
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in Threshold.log
     * *************************************************************
     */
   public static void writeLog(String clientId, String strOption, long input1, long input2, int state, String inputXml, String outputXml) {
       writeLog(clientId, strOption, input1, input2, state,outputXml);//WFS_8.0_127
       writeLog(inputXml, outputXml);
       String cabName = "";
       XMLParser parser = new XMLParser();
       parser.setInputXML(inputXml);
       cabName = parser.getValueOf("EngineName");
       //WFS_8.0_127
		String ThresHoldTime="";
       String ThresHoldSize="";
       ThresHoldTime=WFServerProperty.getSharedInstance().getThresholdData().getProperty(WFSConstant.CONST_THRESHOLD_TIME);

       if(ThresHoldTime==null || ThresHoldTime.equalsIgnoreCase(""))
           ThresHoldTime="5000";

       ThresHoldSize=WFServerProperty.getSharedInstance().getThresholdData().getProperty(WFSConstant.CONST_THRESHOLD_SIZE);

       if(ThresHoldSize==null || ThresHoldSize.equalsIgnoreCase(""))
           ThresHoldSize="102400";

       long execTime = input2-input1;
		//WFS_8.0_127
       if(execTime > Integer.parseInt(ThresHoldTime)){
           StringBuffer message = new StringBuffer();
           message.append("Time Threshold : ");//WFS_8.0_127
           message.append("Time taken by API ");
           message.append(strOption);
           message.append(" is ");
           message.append(execTime);
           message.append(" Client: ");
           message.append(clientId);
           message.append(" StartTime: ");
           message.append(input1);
           message.append(" EndTime: ");
           message.append(input2);
           message.append("\n");
           message.append("Input XML : \n");
           message.append(inputXml);
           message.append("\n");
           message.append("Output XML : \n");
           message.append(outputXml);
		   NGUtil.writeTimeThresholdLog(cabName, WFSConstant.CONST_ORM_MODULE, message);
           message = null;
       }
       if(outputXml.length() > Integer.parseInt(ThresHoldSize)){//WFS_8.0_127
           StringBuffer message = new StringBuffer();
           message.append("Size Threshold : ");
           message.append("Size of API ");
           message.append(strOption);
           message.append(" is ");
           message.append(outputXml.length());
           message.append(" Client: ");
           message.append(clientId);
           message.append(" StartTime: ");
           message.append(input1);
           message.append(" EndTime: ");
           message.append(input2);
           message.append("\n");
           message.append("Input XML : \n");
           message.append(inputXml);
           message.append("\n");
           message.append("Output XML : \n");
           message.append(outputXml);
            NGUtil.writeSizeThresholdLog(cabName, WFSConstant.CONST_ORM_MODULE, message);
            message = null;
       }
   }

	/**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state, String inputXml, String outputXml
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in Threshold.log
     * *************************************************************
     */
   public static void writeLog(String clientId, String strOption, long input1, long input2, int state, String inputXml, String outputXml, String strCabinetName, long connectionTime,int sessionID, int userID) { /* 38914 */
       writeLog(clientId, strOption, input1, input2, state,outputXml,strCabinetName, true,connectionTime,sessionID,userID);

		String ThresHoldTime="";
       String ThresHoldSize="";
       ThresHoldTime=WFServerProperty.getSharedInstance().getThresholdData().getProperty(WFSConstant.CONST_THRESHOLD_TIME);
       if(ThresHoldTime==null || ThresHoldTime.equalsIgnoreCase(""))
           ThresHoldTime="5000";

       ThresHoldSize=WFServerProperty.getSharedInstance().getThresholdData().getProperty(WFSConstant.CONST_THRESHOLD_SIZE);

       if(ThresHoldSize==null || ThresHoldSize.equalsIgnoreCase(""))
           ThresHoldSize="102400";

       long execTime = input2-input1;
		//WFS_8.0_127
       if(execTime > Integer.parseInt(ThresHoldTime)){
           StringBuffer message = new StringBuffer();
           message.append("Time Threshold : ");//WFS_8.0_127
           message.append("Time taken by API ");
           message.append(strOption);
           message.append(" is ");
           message.append(execTime);
           message.append(" Client: ");
           message.append(clientId);
           message.append(" StartTime: ");
           message.append(input1);
           message.append(" EndTime: ");
           message.append(input2);
           message.append("\n");
			if(sessionID != 0){  /* 38914 */
				message.append(" SessionID: ");
				message.append(sessionID);
				message.append(" UserID ");
				message.append(userID);
			}
			message.append("\n");
           message.append("Input XML : \n");
           message.append(inputXml);
           message.append("\n");
           message.append("Output XML : \n");
           message.append(outputXml);
           NGUtil.writeTimeThresholdLog(strCabinetName, WFSConstant.CONST_ORM_MODULE, message);
           message = null;
       }
       if(outputXml.length() > Integer.parseInt(ThresHoldSize)){//WFS_8.0_127
           StringBuffer message = new StringBuffer();
           message.append("Size Threshold : ");
           message.append("Size of API ");
           message.append(strOption);
           message.append(" is ");
           message.append(outputXml.length());
           message.append(" Client: ");
           message.append(clientId);
           message.append(" StartTime: ");
           message.append(input1);
           message.append(" EndTime: ");
           message.append(input2);
           message.append("\n");
			if(sessionID != 0){  /* 38914 */
				message.append(" SessionID: ");
				message.append(sessionID);
				message.append(" UserID ");
				message.append(userID);
			}
			message.append("\n");
           message.append("Input XML : \n");
           message.append(inputXml);
           message.append("\n");
           message.append("Output XML : \n");
           message.append(outputXml);
          NGUtil.writeSizeThresholdLog(strCabinetName, WFSConstant.CONST_ORM_MODULE, message);
          message = null;
       }
   }


    /**
     * *************************************************************
     * Function Name    :   writeLog
     * Author			:   Kahkeshan
     * Date Written     :  23/10/2013
     * Input Parameters :   String -> clientId,
     *						String -> strOption, String input1,
     *						String -> input2, int state
     * Output Parameters:   NONE
     * Return Value     :   void
     * Description      :   Log in XML.log
     * *************************************************************
     */
   public static void writeLog(String input1, String input2) {
       StringBuffer message = new StringBuffer();
       message.append(input1);
       message.append(System.getProperty("line.separator"));
       message.append(input2);
       NGUtil.writeXmlLog("",WFSConstant.CONST_ORM_MODULE,input1,input2);
        
       message = null;
   }

     /**
     * *************************************************************
     * Function Name    :   isLogEnabled
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   char -> logType, Level -> level
     * Output Parameters:   NONE
     * Return Value     :   boolean
     * Description      :   To avoid cost of parameter construction
     * *************************************************************
     */


    public static String generalError(String txnName, String cabinetName, XMLGenerator generator, int error, String errorMessage) {
        StringBuffer strOutputBuffer = new StringBuffer();
        try {
            strOutputBuffer.append(generator.createOutputFile(txnName));
            strOutputBuffer.append(generator.writeValueOf("Status", String.valueOf(error)));
            strOutputBuffer.append(generator.writeValueOf("Error", errorMessage));
            strOutputBuffer.append(generator.closeOutputFile(txnName));
        } catch (Exception e) {
            WFSUtil.printErr(cabinetName,"[WFClientServiceHandler] generalError() I " + e);
            WFSUtil.printErr(cabinetName,"General Exception Occured(In Function generalError(JTS)) at time " + new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm:ss", Locale.US).format(new java.util.Date()) + " with message " + e.getMessage());
        }
        return strOutputBuffer.toString();
    } 
    public static String generalError(String txnName, String engineName, XMLGenerator generator, int mainErrorCode, int subErrorCode, String typeOfError, String errorMessage, String errorDescription) {
        StringBuffer strOutputBuffer = new StringBuffer();
        try {
            strOutputBuffer.append(generator.createOutputFile(txnName));
            strOutputBuffer.append(generator.writeValueOf("Status", String.valueOf(mainErrorCode)));
            strOutputBuffer.append("<Error>");
            strOutputBuffer.append("<Exception>");
            strOutputBuffer.append(generator.writeValueOf("MainCode", String.valueOf(mainErrorCode)));
            strOutputBuffer.append(generator.writeValueOf("SubErrorCode", String.valueOf(subErrorCode)));
            strOutputBuffer.append(generator.writeValueOf("TypeOfError", String.valueOf(typeOfError)));
            strOutputBuffer.append(generator.writeValueOf("Subject", String.valueOf(errorMessage)));
            strOutputBuffer.append(generator.writeValueOf("Description", errorDescription));
            strOutputBuffer.append("</Exception>");
            strOutputBuffer.append("</Error>");
            strOutputBuffer.append(generator.closeOutputFile(txnName));
        } catch (Exception e) {
        }
        return strOutputBuffer.toString();
    }

public static void writeLog(String input1, String input2, String strCabinetName, boolean flag) {
         /*User/API logging support- sajid khan**/
        /******************************************/
        String strArr[] = WFSUtil.returnUserApiStatus();
        String uName = strArr[0];
        String userApiStatus = strArr[1];
        StringBuffer message = new StringBuffer();
        message.append(" ["+uName+"]  "+input1);
        message.append(System.getProperty("line.separator"));
        message.append(" ["+uName+"]  "+input2);
        if(userApiStatus.equals("10")){
            NGUtil.writeUserXmlLog(strCabinetName,WFSConstant.CONST_ORM_MODULE ,message);
         }else if (userApiStatus.equals("01")){
            NGUtil.writeApiXmlLog(strCabinetName,WFSConstant.CONST_ORM_MODULE, message);
         }else if (userApiStatus.equals("11")){
            NGUtil.writeUserXmlLog(strCabinetName, WFSConstant.CONST_ORM_MODULE, message);
         }
        NGUtil.writeXmlLog(strCabinetName, WFSConstant.CONST_ORM_MODULE," ["+uName+"] "+ input1," ["+uName+"]  "+  input2);
        
        message = null;
        //writeLog(input1, input2);
    }

/**
     * *************************************************************
     * Function Name    :   readFileAsResource
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   String -> fileName
     * Output Parameters:   NONE
     * Return Value     :   String -> fileBuffer.
     * Description      :   Reads file embedded in Jar
     * *************************************************************
     */
    public static String readFileAsResource(String fileName) {
        InputStream input = WFRMSUtil.class.getClassLoader().getResourceAsStream(fileName);
        BufferedReader bReader = null;
        String line = "";
        StringBuffer temp = new StringBuffer();
        try {
            if (input != null) {
                bReader = new BufferedReader(new InputStreamReader(input));
                line = bReader.readLine();
                while (line != null) {
                    temp.append(line);
                    line = bReader.readLine();
                }
            }
        } catch (IOException ioe) {
            //printErr(Level.DEBUG,"", ioe);
        } finally {
            try {
                if (bReader != null) {
                    bReader.close();
                    bReader = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (input != null) {
                    input.close();
                    input = null;
                }
            } catch (Exception ignored) {
            }
        }
        return temp.toString();
    }
/**
     * *************************************************************
     * Function Name    :   getLikeFilterStr
     * Programmer' Name :   Kahkeshan
     * Date Written     :   October 23 2013
     * Input Parameters :   XMLParser -> parser
     *                      String    -> columnName
     *                      String    -> data
     *                      int       -> dbType
     *                      boolean   -> UTF8Flag
     * Output Parameters:   NONE
     * Return Value     :   String -> like filter String
     * Description      :   Returns like filter string
     *                      Upper(RTrim(<COLUMN_NAME>)) LIKE
     *                      Upper(RTrim(<DATA>)) ESCAPE N'\\'
     * *************************************************************
     */
    public static String getLikeFilterStr(XMLParser parser, String columnName, String data, int dbType, boolean UTF8Flag, int varType) {
        String returnStr = null;
        if (dbType == JTSConstant.JTS_MSSQL) {
            data = WFRMSUtil.replace(parser.convertToSQLString(data), "*", "%");
        } else {
            data = WFRMSUtil.replace(parser.convertToSQLString(data, dbType), "*", "%");
        }
        returnStr = " " + TO_STRING(columnName, false, dbType) + " LIKE " + TO_STRING(TO_STRING(data, true, dbType), false, dbType);
        /** @todo Need to check in DB2 - Ruhi Hira */
        /** 11/11/2008, Bugzilla Bug 6941, PickList give error when search with some value in int field in Oracle.
         * - Ruhi Hira */
        if (varType == WFSConstant.WF_STR) {
            if ((dbType == JTSConstant.JTS_ORACLE && UTF8Flag) || dbType == JTSConstant.JTS_DB2) {
                if ((returnStr.indexOf("_") != -1) || (returnStr.indexOf("[\\%]") != -1)) {
                    returnStr += " Escape " + WFRMSUtil.TO_STRING("\\", true, dbType);
                }
            }
        }
        returnStr += " ";
        return returnStr;
    }

    public static String getLikeFilterStr(XMLParser parser, String columnName, String data, int dbType, boolean UTF8Flag) {
        return getLikeFilterStr(parser, columnName, data, dbType, UTF8Flag, WFSConstant.WF_STR);
    }
    	 /**
     * *************************************************************
     * Function Name    :   getProfileList
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   Statement stmt, int profileId, int associationType
     * Output Parameters:   ArrayList
     * Return Value     :   profileList
     * Description      :   Return profileList associated with one User/Group
     * *************************************************************
     */
   
   public static HashMap getProfileList(Statement stmt, int profileId, int associationType) throws SQLException{
		String strQuery = null;
		ResultSet rs = null;
		//ArrayList<Integer> profileList = null;
		HashMap profileMap = null;
		char char21 = 21;
		String string21 = "" + char21;
		try{
			//profileList = new ArrayList<Integer>();
			profileMap = new HashMap();
			//printOut("Select UserId, AssignedTillDateTime, AssociationFlag from WFUserObjAssocTable where ProfileId = " + profileId + " AND AssociationType = " + associationType);
			rs = stmt.executeQuery("Select UserId, AssignedTillDateTime, AssociationFlag from WFUserObjAssocTable  where ProfileId = " + profileId + " AND AssociationType = " + associationType);
			while(rs.next()){
				//profileList.add(rs.getInt(1));
				profileMap.put(rs.getInt(1),rs.getString(2)+string21+rs.getString(3));
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
		} finally{
			if(rs != null){
				rs.close();
				rs = null;
			}
		}
		//return profileList;
		return profileMap;
	}
   /**
     * *************************************************************
     * Function Name    :   compareRightsOnObject
     * Author			:   Kahkeshan
     * Date Written     :   23/10/2013
     * Input Parameters :   String ObjectRightString, Int RightOrderIndex
     * Output Parameters:   boolean
     * Return Value     :   
     * Description      :   
     * *************************************************************
     */	
	public static boolean compareRightsOnObject(String objectRightString, int rightOrderIndex) {  
		boolean isRight = false;
		if(objectRightString.charAt(rightOrderIndex-1)=='1'){
			isRight = true;
		}
		return isRight;
	}
        /**
     * *************************************************************
     * Function Name    :   getDATEType
     * Programmer' Name :   Kahkeshan
     * Date Written     :   October 23 2013
     * Input Parameters :   int -> dbType
     * Output Parameters:   NONE
     * Return Value     :   String -> Date type.
     * Description      :   Date type specific to database.
     * *************************************************************
     */
    public static String getDATEType(int dbType) {
        String varcharType = null;
        switch (dbType) {
            case JTSConstant.JTS_MSSQL:
                varcharType = " DATETIME ";
                break;
            case JTSConstant.JTS_ORACLE:
                varcharType = " DATE ";
                break;
            case JTSConstant.JTS_POSTGRES:
            case JTSConstant.JTS_DB2:
                varcharType = " TIMESTAMP ";
                break;
            default:
        }
        return varcharType;
    }
 /**
     * *************************************************************
     * Function Name    :   getQueryLockHintStr
     * Programmer' Name :   Kahkeshan
     * Date Written     :   October 23 2013
     * Input Parameters :   int -> dbType
     * Output Parameters:   NONE
     * Return Value     :   String -> Returns lock hint string for query.
     * Description      :   With UR For DB2 [Bugzilla Id 54]
     * *************************************************************
     */
    public static String getQueryLockHintStr(int dbType) {
        String lockHintStr = "";
        switch (dbType) {
            case JTSConstant.JTS_DB2:
                lockHintStr = "JTSConstant WITH UR ";
                break;
            case JTSConstant.JTS_MSSQL:
            case JTSConstant.JTS_ORACLE:
            case JTSConstant.JTS_POSTGRES:
            default:
        }
        return lockHintStr;
    }
    
    
	/**
     * *************************************************************
     * Function Name    :   getRightsOnObjectsForUser
     * Author			:   Mohnish Chopra
     * Date Written     :   05/02/2014
     * Input Parameters :   Connection con, int dbType, String objectType, int sessionID , int projectId
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   Return Objects with RightString for an object type to avoid multiple calls on getRightsOnObject method
     * *************************************************************
     */
    
    
    public static String  getRightsOnObjectsForUser(Connection con, int dbType, String objectType, int sessionID,int projectId) throws SQLException, Exception{
    	return getRightsOnObjectsForUser(con,dbType,objectType,sessionID,projectId,0);
    }
    
    
	public static String  getRightsOnObjectsForUser(Connection con, int dbType, String objectType, int sessionID,int projectId,int userIndex) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rightsXML = null;
		String tempXMLString =null;
		try{
			WFParticipant user = WFCheckSession(con, sessionID);
            int userId = 0;
            /* Bug 38083 fixed, WFSException will be returned in case of user = null*/
            if(user != null)
                userId = user.getid();
            else{   
                int mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                int subCode = 0;
                String subject = WFSErrorMsg.getMessage(mainCode);
                String descr = WFSErrorMsg.getMessage(subCode);
                String errType = WFSError.WF_TMP;
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            }    
			String userName = user.getname();
			int noOfRecToFetch = 1;
			String sortOrder = "A";
			String lastValue = "";
			//String filterString = null;
			boolean isRightCheck = false;
			

                pstmt = con.prepareStatement("Select DefaultRight from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = ?");
                pstmt.setString(1, objectType);
                rs = pstmt.executeQuery();
                String defaultString = null;
                if(rs.next()){
                    defaultString = rs.getString("DefaultRight");
                }
                //rights = getRightsOnObject(con, dbType, objectType, objectId, sessionID, defaultString);
                if(userIndex==0)
                rightsXML = returnRightsXMLForObjectType(con, dbType, userId, objectType, sortOrder,  isRightCheck, defaultString,projectId);
                else
                rightsXML = returnRightsXMLForObjectType(con, dbType, userIndex, objectType, sortOrder,  isRightCheck, defaultString,projectId);
                if(rightsXML == null || rightsXML == ""){
                	rightsXML = defaultString;
                }
                
			StringBuffer logProp= new StringBuffer("UserId::"+userId+" UserName::"+userName+" ObjectType::"+objectType+" RightString: "+rightsXML);
			
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
		}
		return rightsXML;
	}
	
	/**
     * *************************************************************
     * Function Name    :   returnRightsXMLForObjectType
     * Author			:   Mohnish Chopra
     * Date Written     :   05/02/2014
     * Input Parameters :   Connection con, int dbType, String objectType, int sessionID , int projectId
     * Output Parameters:   String
     * Return Value     :   String
     * Description      :   Return XML Containing 
     * 						i) objectId's for objects on which user have rights
     * 						ii)user's right string for the object type  	 
     * *************************************************************
     */
	public static String returnRightsXMLForObjectType(Connection con, int dbType, int userId, String objType, String sortOrder, boolean isRightCheck, String defaultString, int projectId) throws SQLException, Exception{
		PreparedStatement pstmt = null;
		CallableStatement cstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String rights = null;
		String filterString = null;
		String tempRightTable = null;
		String objRightString = "";
		Map<Integer, String> objIdRightStringMap = new HashMap<Integer, String>();
		StringBuffer tempXml = new StringBuffer();
		ResultSet cursorResultSet = null;
		Statement stmtForCursor = null;
        String cursorName = "";
		try{
			if(defaultString==null ||defaultString.equals("")){
				pstmt = con.prepareStatement("Select DefaultRight from WFObjectListTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ObjectType = ?");
				pstmt.setString(1, objType);
				rs = pstmt.executeQuery();
				if(rs.next()){
					defaultString = rs.getString("DefaultRight");
				}
			}
/*			if(projectId>0){
				filterString=" ProjectId = "+projectId+ " ";
			}*/
			tempRightTable = getTempTableName(con, "TempObjectRightsTable", dbType);
			//createTempRightTable(con, dbType);
			String typeNVARCHAR = getNVARCHARType(dbType);
			
			//printOut("tempRightTable " + tempRightTable);
			stmt = con.createStatement();
			createTempTable(stmt, tempRightTable, "AssociationType INT, ObjectId INT, ObjectName " + typeNVARCHAR + "(64), RightString " + typeNVARCHAR + "(100) " , dbType); /*Bug 40277*/
			String[] qParam = executeGetQueryParam(con, dbType, objType); 
			
			if (dbType == JTSConstant.JTS_MSSQL) {
				cstmt = con.prepareCall("{call WFReturnRightsForUser(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt = con.prepareCall("{call WFReturnRightsForUser(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}");
			}else if (dbType == JTSConstant.JTS_POSTGRES) {
                cstmt = con.prepareCall("{call WFReturnRightsForUser(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                 con.setAutoCommit(false);
         }
			cstmt.setInt(1, userId);
            //cstmt.setInt(2, 2);
            cstmt.setString(2, objType);
            cstmt.setString(3, qParam[0]);
			cstmt.setString(4, qParam[1]);
            cstmt.setString(5, qParam[2]);
            cstmt.setString(6, tempRightTable);
            cstmt.setString(7, sortOrder);
   /*         cstmt.setInt(8, batchSize);
            if(lastVal == null || lastVal.equals(""))
                cstmt.setNull(9, java.sql.Types.VARCHAR);
            else
                cstmt.setString(9, lastVal);*/
			if(filterString == null || filterString.equals(""))
                cstmt.setNull(8, java.sql.Types.VARCHAR);
            else
                cstmt.setString(8, filterString);
			cstmt.setInt(9, projectId);
			if (dbType == JTSConstant.JTS_ORACLE) {				
				cstmt.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
				cstmt.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);				
			}	
			
			cstmt.execute();
			if (dbType == JTSConstant.JTS_MSSQL) /* ResultSet 1 -> User' Preferences */ {
				rs = cstmt.getResultSet();
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				rs = (ResultSet) cstmt.getObject(10);			
			}else if (dbType == JTSConstant.JTS_POSTGRES ) {
                cursorResultSet = cstmt.getResultSet();
                stmtForCursor = con.createStatement();
                if(cursorResultSet.next()){
                    cursorName = cursorResultSet.getString(1);
                    if(rs!=null){
                        rs.close();
                        rs = null;
                    }
                    rs = stmtForCursor.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName,true) + "\"");
                }
            }  
			
			boolean found = false;
			String rightString = null;
			BitSet bs1 = null;
			BitSet bs2 = null;
			while(rs.next()){

				if(objIdRightStringMap.containsKey(rs.getInt("ObjectId"))){
					bs1 = createBitset(objIdRightStringMap.get(rs.getInt("ObjectId")));
					bs2 = createBitset(rs.getString("RightString"));
					bs1.or(bs2);
					objIdRightStringMap.put(rs.getInt("ObjectId"), bitToString(bs1));
					
				}
				else{
					objIdRightStringMap.put(rs.getInt("ObjectId"), rs.getString("RightString"));
				}
				/*objectIdSet.add(rs.getInt("ObjectId"));
				rightString = rs.getString("RightString");
				objTypeRightString.add(rightString);
				//objTypeRightString.add(rs.getString("RightString"));
				found = true;*/
			}
			
			//int size = objTypeRightString.size();
			//printOut("size::"+size);

			//Handling for ObjectType which doesnot contain ObjectId
			boolean ObjectTypeWithoutObjsflag = false;
			Iterator objIdRightStringIterator = null;
	    	tempXml.append("<ObjectType>");
			if(objIdRightStringMap.size()!=0){
				objIdRightStringIterator = objIdRightStringMap.entrySet().iterator();
			    while (objIdRightStringIterator.hasNext()) {
			    Map.Entry pair = (Map.Entry)objIdRightStringIterator.next();
				    if((Integer)pair.getKey()==-1){
				    	ObjectTypeWithoutObjsflag = true;
						tempXml.append("<RightString>");
						tempXml.append((String)pair.getValue());
						tempXml.append("</RightString>");
						break;
				    }
				    else{
				    	break;
				    }
			    }
			}else{
				ObjectTypeWithoutObjsflag = true;
				tempXml.append("<RightString>");
					tempXml.append(defaultString);
				tempXml.append("</RightString>");
			}
			tempXml.append("</ObjectType>");
			
			if(ObjectTypeWithoutObjsflag == false ){
				tempXml = new StringBuffer();
		    	tempXml.append("<ObjectType>");
		    	tempXml.append("<ObjectIdList>");
		    	objIdRightStringIterator = objIdRightStringMap.entrySet().iterator();
		    	while (objIdRightStringIterator.hasNext()) {
				    Map.Entry pair = (Map.Entry)objIdRightStringIterator.next();
				    tempXml.append("<Object>");
				    tempXml.append("<ObjectId>");
				    tempXml.append(pair.getKey());
				    tempXml.append("</ObjectId>");
				    tempXml.append("<RightString>");
					tempXml.append(pair.getValue());
					tempXml.append("</RightString>");
				    tempXml.append("</Object>");
		    	}
		    	tempXml.append("</ObjectIdList>");
		    	tempXml.append("</ObjectType>");
			}
			if (dbType == JTSConstant.JTS_POSTGRES) {
                con.commit();
                con.setAutoCommit(true);
            }	
			 if(cursorResultSet != null){
                 cursorResultSet.close();
                 cursorResultSet = null;
}
             if(stmtForCursor != null){
                 stmtForCursor.close();
                 stmtForCursor = null;
}
		}finally{
			if(stmt != null){                
				try{
					dropTempTable(stmt, tempRightTable, dbType);
				} catch(Exception excp){}
	        }
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(cursorResultSet != null){
					cursorResultSet.close();
					cursorResultSet = null;
				}
				if(stmtForCursor != null){
					stmtForCursor.close();
					stmtForCursor = null;
				}
			}catch(Exception ignored){}
            try{
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
                if(cstmt != null){
					cstmt.close();
					cstmt = null;
				}
			}catch(Exception ignored){}
		}
		
		return tempXml.toString();
	}
	
	
	public static String getAssociatedObjsList(Connection con, int profileId, int objTypeId, int userId, int assocType, String engine, int dbType) throws Exception {
		StringBuilder outputXML = new StringBuilder();
		String[] queryParamArray = WFSUtil.executeGetQueryParam(con, objTypeId);
		StringBuilder filterStr = new StringBuilder(200);
		StringBuilder qBuffer = new StringBuilder();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		filterStr.append(" where ObjectTypeId = ? and UserId = ? and AssociationType = ? AND ProfileId = ? ");
		
		filterStr.append(TO_SANITIZE_STRING(queryParamArray[2], true));
		qBuffer.append("Select * from(select ObjectId, RightString,  ");
		qBuffer.append(TO_SANITIZE_STRING(queryParamArray[0], true));
		qBuffer.append(" ObjectName from WFUserObjAssocTable "+ WFSUtil.getTableLockHintStr(dbType) +",");
		qBuffer.append(TO_SANITIZE_STRING(queryParamArray[1], true));
		qBuffer.append(filterStr);
		qBuffer.append(") QueryAssocObject Where 1 = 1 ");
		WFRMSUtil.printOut(engine," QueryString::"+qBuffer.toString());
		
		try{
			pstmt = con.prepareStatement(qBuffer.toString());
			pstmt.setInt(1, objTypeId);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, assocType);
			pstmt.setInt(4, profileId);
			if(profileId != 0){
				pstmt.setInt(4, profileId);
			}
			rs = pstmt.executeQuery();
			int retCount = 0;
			int totalCount = 0;
			outputXML.append("<ObjectIdList>");
			while(rs.next()){
				outputXML.append("<Object>");
				outputXML.append("<ObjectId>" + rs.getString("ObjectId") + "</ObjectId>");
				outputXML.append("<ObjectName>" + rs.getString("ObjectName") + "</ObjectName>");
				outputXML.append("<RightString>" + rs.getString("RightString") + "</RightString>");
				outputXML.append("</Object>");
			}
			outputXML.append("</ObjectIdList>");
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				
			}
			
		}
	    return outputXML.toString();
	}
	
	public static String TO_SANITIZE_STRING(String in, boolean isQuery) {
		if (in != null) {

			if (!isQuery) {
				return in.replaceAll("'", "''");
			} else {
				String newStr = in.replaceAll("'", "''");

				return newStr.replaceAll("''", "'");
			}
		}
		return null;
	}
	/**
	 * Method details : 
	 * @param con
	 * @param objTypeId
	 * @param objName
	 * @param dbType
	 * @param engine
	 * @param userObjType
	 * @return
	 * @throws Exception
	 * 
	 * This method returns the object Id for the given object name and object Type Id.
	 * objTypeId => 1 to 14 defined in WFObjectListTable
	 * Note - UserObjType will be considered only when ObjTypeId = 0
	 * userObjType => 0-> User, 1->Group, 2-> Profile, 3->Role.
	 * 
	 */
	public static int getObjIdForObjName(Connection con, int objTypeId, String objName, int dbType, String engine, int userObjType) throws Exception{
		if(objName == null || objName.trim().isEmpty()){
			return 0;
		}
		objName = objName.trim().toUpperCase();
		
		int newObjId = 0;
		Statement stmt = null;
		ResultSet rs = null;
		String columnName = null;
		String tableName = null;
		String columnIndex = null;
		try{
						
			if(objTypeId > 0 && userObjType <0 ){
				String[] queryParamArray = null;
				if(objectTypeDetailsMap.containsKey(objTypeId)){
					queryParamArray = objectTypeDetailsMap.get(objTypeId);
				}else{
					queryParamArray = WFSUtil.executeGetQueryParam(con, objTypeId);
					objectTypeDetailsMap.put(objTypeId, queryParamArray);
				}
				columnName = queryParamArray[0];
				tableName = queryParamArray[1];
				columnIndex = queryParamArray[2];
				if(columnIndex != null && !columnIndex.isEmpty()){
					if(columnIndex.contains("AND") && columnIndex.contains("=")){
						int andIndex = columnIndex.indexOf("AND") + 3;
						int equalIndex = columnIndex.indexOf("=");
						columnIndex = columnIndex.substring(andIndex, equalIndex).trim();
						WFRMSUtil.printOut(engine,"WFRMSUtil:getObjIdForObjName ColumnIndex Name for Object Type " + columnIndex);
					}
				}
			}
			else if(userObjType >= 0){
				if(userObjType == 0){
					columnName = "UserName";
					columnIndex = "UserIndex";
					tableName = "PDBUser";
				}
				else if(userObjType == 1){
					columnName = "GroupName";
					columnIndex = "GroupIndex";
					tableName = "PDBGroup";
				}
				else if(userObjType == 2){
					columnName = "ProfileName";
					columnIndex = "ProfileId";
					tableName = "WFProfileTable";
				}
				else if(userObjType == 3){
					columnName = "RoleName";
					columnIndex = "RoleIndex";
					tableName = "PDBRoles";
				}
			}
			tableName=TO_SANITIZE_STRING(tableName, true);
			columnName=TO_SANITIZE_STRING(columnName, true);
			columnIndex=TO_SANITIZE_STRING(columnIndex, true);
			String queryStr = "select distinct " + columnIndex + " from " + tableName + WFSUtil.getTableLockHintStr(dbType) + " where UPPER(" + columnName + ") = UPPER('" + objName + "')";
			WFRMSUtil.printOut(engine,"WFRMSUtil:getObjIdForObjName Query to get the updated Id for object " + objName + " is : " + queryStr);
			stmt = con.createStatement();
			rs = stmt.executeQuery(queryStr);
			if(rs != null && rs.next()){
				newObjId = rs.getInt(columnIndex);
			}
			
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(stmt != null){
				stmt.close();
				stmt = null;
			}
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				
			}
			try{
			if(stmt != null){
				stmt.close();
				stmt = null;
			}}catch(Exception e){
				
			}
		}
		return newObjId;
	}
	
	public static String generateOutputLogInfo( int objId, String objName, String reason, int messageType) {
		StringBuilder returnStr = new StringBuilder();
		switch(messageType){
		case 0:
			returnStr.append("<SuccessInfo><ObjectId>" + objId + "</ObjectId><ObjectName>" + objName + "</ObjectName><Action>" + reason + "</Action></SuccessInfo>");
			break;
		case 1:
			returnStr.append("<WarningInfo><ObjectId>" + objId + "</ObjectId><ObjectName>" + objName + "</ObjectName><Reason>" + reason + "</Reason></WarningInfo>");
			break;
		case 2:
			returnStr.append("<FailureInfo><ObjectId>" + objId + "</ObjectId><ObjectName>" + objName + "</ObjectName><Reason>" + reason + "</Reason></FailureInfo>");
			break;
		default:
			returnStr.append("<SuccessInfo><ObjectId>" + objId + "</ObjectId><ObjectName>" + objName + "</ObjectName></SuccessInfo>");
			break;
		}
		return returnStr.toString();
	}
	
	public static String invokeRestAPIs(String inputXml, String url, String engine) throws Exception{
		WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs inputXml " + inputXml);
		WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs url " + url);
		int restStatusCode = 200;
		String outputXml = null;
		try{
			JerseyClient jerseyClient = JerseyClientBuilder.createClient().property(ClientProperties.CONNECT_TIMEOUT, 10000).property(ClientProperties.READ_TIMEOUT, 10000);
			WebTarget con = jerseyClient.target(url);
			Builder builder = con.request(MediaType.APPLICATION_XML).accept(MediaType.APPLICATION_XML);
			Response response = builder.post(Entity.entity(inputXml, MediaType.APPLICATION_XML), Response.class);
			if(response != null){
				restStatusCode = response.getStatus();
				outputXml = response.readEntity(String.class);
				WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs response.getStatus() " + restStatusCode);
				WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs response.getStatus() " + outputXml);
				if(restStatusCode != 200){
					WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs REST invocation unsuccessfull. restStatusCode " + restStatusCode);
					throw new WFSException(WFSError.WF_REST_SERVICE_INVOCATION_FAILED, 0, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_REST_SERVICE_INVOCATION_FAILED), WFSErrorMsg.getMessage(WFSError.WF_REST_SERVICE_INVOCATION_FAILED));
				}
			}else{
				WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs Error occurred on REST invokation..REST Response is null");
				throw new WFSException(WFSError.WF_REST_SERVICE_INVOCATION_FAILED, 0, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_REST_SERVICE_INVOCATION_FAILED), WFSErrorMsg.getMessage(WFSError.WF_REST_SERVICE_INVOCATION_FAILED));
			}
		}catch(Exception ex){
			WFRMSUtil.printOut(engine,"WFRMSUtil.invokeRestAPIs Error occurred on REST invokation");
			printErr(engine, ex);
			throw ex;
		}
		return outputXml;
	}
	
	public static String[] WFMigrateGroupRightsData(Connection con, int sessionId, int oldGroupId, String groupName, String engine, int dbType, 
			Set<String> existingGroupsList, XMLGenerator gen, String targetUrl, String localRestUrl, String targetEngineName, int targetSessionId,
			String overwriteProfileGroupPropertyAndRights, Map<String, Integer> objectTypeNameMap) throws Exception{
		StringBuffer apiInputXml = new StringBuffer();
		PreparedStatement pstmt = null;
		PreparedStatement stmt = null;
		PreparedStatement pstmt1 = null;
		Statement stmt1 = null;
		ResultSet rs = null;
		String query = "";
		StringBuilder warningObjList = new StringBuilder();
		StringBuilder failedObjList = new StringBuilder();
		StringBuilder successObjList = new StringBuilder();
		boolean groupExists = false;
		try{
			int newGroupId = 0;
			WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Migration started for the group : " + groupName);
			
			//Calling Omnidocs method to get the Basic group details.
			apiInputXml = CreateXML.NGOGetGroupProperty(targetEngineName, targetSessionId+"", oldGroupId);
	    	XMLParser tmpParser = new XMLParser(apiInputXml.toString());
	    	String apiOutput = invokeRestAPIs(apiInputXml.toString(), targetUrl + "/WFGetGroupProperty", engine);
	        tmpParser.setInputXML(apiOutput);
	        
			WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOGetGroupProperty Input XML: " + apiInputXml.toString() + ", Output XML : " + apiOutput);
	        
			String status = tmpParser.getValueOf("Status");
	        if("0".equalsIgnoreCase(status)){
	        	apiInputXml = new StringBuffer();
	        	String mainGroupIndex = tmpParser.getValueOf("MainGroupIndex");
	        	groupName = tmpParser.getValueOf("GroupName");
	        	String creationDateTime = tmpParser.getValueOf("CreationDateTime");
	        	String expiryDateTime = tmpParser.getValueOf("ExpiryDateTime");
	        	String privileges = tmpParser.getValueOf("Privileges");
	        	String ownerName = tmpParser.getValueOf("OwnerName");
	        	int ownerIndex = getObjIdForObjName(con, 0, ownerName, dbType, engine, 0);
	        	String groupType = tmpParser.getValueOf("GroupType");
	        	String comment = tmpParser.getValueOf("Comment");
	        	//String ownerName = tmpParser.getValueOf("OwnerName");
	        	String parentGroupIndexStr = tmpParser.getValueOf("ParentGroupIndex");
	        	int parentGroupIndex = Integer.parseInt(parentGroupIndexStr);
	        	String ownerType = tmpParser.getValueOf("OwnerType");
	        	
	        	//Fetch the parentgroup details..
	        	if(parentGroupIndex != 0){
	    			apiInputXml = CreateXML.NGOGetGroupProperty(targetEngineName, targetSessionId+"", parentGroupIndex);
	    			apiOutput = invokeRestAPIs(apiInputXml.toString(), targetUrl + "/WFChangeGroupProperty", engine);
			    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOChangeGroupProperty Input XML: " + apiInputXml.toString() + ", Output XML : " + apiOutput);
			        tmpParser.setInputXML(apiOutput);
			        status = tmpParser.getValueOf("Status");
			        if("0".equalsIgnoreCase(status)){
			        	String parentGroupName = tmpParser.getValueOf("GroupName");
				    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOGetGroupProperty fetched the parentGroup Name : " + parentGroupName);
				    	parentGroupIndex = getObjIdForObjName(con, 0, parentGroupName, dbType, engine, 1);
				    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Final ParentGroupIndex : " + parentGroupIndex);
			        }else{
				    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOGetGroupPropertyFailed to fetch the parentgroup details : " + status);
				    	parentGroupIndex = 1;
			        }
	        	}
	        	if(ownerIndex == 0){
	        		ownerIndex = 2;		//Make supervisors as group owner if not found 
	        	}
	        	
	        	
	        	//If Group exists on the target cabinet..then update the group property..Otherwise create the group on target cabinet.
	        	if(existingGroupsList.contains(groupName.trim().toUpperCase())){
	        		
	        		//Return from this point if overwriteProfileGroupPropertyAndRights flag is false
	        		if("N".equalsIgnoreCase(overwriteProfileGroupPropertyAndRights.trim())){
	        			return new String[]{"","",""};
	        		}
	        		
	        		groupExists = true;
			    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Group already exists on the cabinet, updating the group property.");
	
			    	//If group already exists, then update groupId with the ID of existing group on the target cabinet..
	        		newGroupId = getObjIdForObjName(con, 0, groupName, dbType, engine, 1);
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : GroupId of the group at the target cabinet is : " + newGroupId);
	        		
					apiInputXml = CreateXML.NGOChangeGroupProperty(engine, sessionId+"", newGroupId, groupName, comment, groupType, parentGroupIndex, ownerIndex, ownerType, privileges);
			    	tmpParser = new XMLParser(apiInputXml.toString());
			    	apiOutput = invokeRestAPIs(apiInputXml.toString(), localRestUrl + "/WFChangeGroupProperty", engine);
	
			    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOChangeGroupProperty Input XML: " + apiInputXml.toString() + ", Output XML : " + apiOutput);
			        tmpParser.setInputXML(apiOutput);
			        status = tmpParser.getValueOf("Status");
	        	}else{
			    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Group does not exists on the target cabinet, Creating new group on the target.");
	
			    	apiInputXml = CreateXML.NGOAddGroup(engine, sessionId+"", groupName, comment, groupType, parentGroupIndex, ownerIndex, ownerType);
			    	tmpParser = new XMLParser(apiInputXml.toString());
			    	apiOutput = invokeRestAPIs(apiInputXml.toString(), localRestUrl + "/WFAddGroup", engine);
					
			    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : NGOAddGroup Input XML: " + apiInputXml.toString() + ", Output XML : " + apiOutput);
			        tmpParser.setInputXML(apiOutput);
			        status = tmpParser.getValueOf("Status");
			        if("0".equalsIgnoreCase(status)){
				        String groupIdString = tmpParser.getValueOf("GroupIndex");
				        newGroupId = Integer.parseInt(groupIdString);
				    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : New GroupId of the group on the target cabinet : " + newGroupId);
				    	existingGroupsList.add(groupName.trim().toUpperCase());
			        }else{
				    	WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Group Creation failed for group Name : " + groupName);
			        }
	        	}
	
		        //If group is created/Updated successfully, then fetch and set the group's direct associations
		        if("0".equalsIgnoreCase(status)){
		        	
		        	//Get the list of already associated objectTypes with the group:
		        	Set<Integer> associatedObjTypesList = new HashSet<Integer>();
		        	query = "select distinct ObjectTypeId from WFProfileObjTypeTable "+ WFSUtil.getTableLockHintStr(dbType) +" where UserId = ? and AssociationType = 1";
		        	pstmt = con.prepareStatement(query);
		        	pstmt.setInt(1, newGroupId);
		        	rs = pstmt.executeQuery();
		        	while(rs.next()){
		        		int associatedObjTypeId = rs.getInt("ObjectTypeId");
		        		associatedObjTypesList.add(associatedObjTypeId);
		        	}
					if(rs != null){
						rs.close();
						rs = null;
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					
	        		apiInputXml = CreateXML.WFGetUserObjTypeAssociation(targetEngineName, targetSessionId+"", oldGroupId, 1);
			    	tmpParser = new XMLParser(apiInputXml.toString());
			    	apiOutput = invokeRestAPIs(apiInputXml.toString(), targetUrl + "/WFGetUserObjTypeAssociation", engine);
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : WFGetUserObjTypeAssociation Input : " + apiInputXml.toString() + ", Output : " + apiOutput);
					tmpParser.setInputXML(apiOutput);
					
					String apiMainCode = tmpParser.getValueOf("MainCode");
					if("0".equalsIgnoreCase(apiMainCode)){
						String objectTypes = tmpParser.getValueOf("ObjectTypes");
						tmpParser.setInputXML(objectTypes);
						int noOfAssociatedObjTypes = tmpParser.getNoOfFields("ObjectType");
						WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : noOfAssociatedObjTypes with the group : " + noOfAssociatedObjTypes);
						
						if(noOfAssociatedObjTypes > 0){
							for(int inx = 0; inx < noOfAssociatedObjTypes; inx++){
								String objectType = ((inx > 0) ? tmpParser.getNextValueOf("ObjectType") : tmpParser.getFirstValueOf("ObjectType"));
								XMLParser objTypeParser = new XMLParser(objectType);
								
								String objectTypeName = objTypeParser.getValueOf("ObjectTypeName");
								int objectTypeId = objectTypeNameMap.get(objectTypeName.trim().toUpperCase());
								
								boolean isObjList = "Y".equalsIgnoreCase(objTypeParser.getValueOf("IsObjList"));
								String assignedTillDateTime = objTypeParser.getValueOf("AssignedTillDateTime");
								String rightString = WFSConstant.CONST_DEFAULT_RIGHTSTR_ZERO;
								if(!isObjList){
									rightString = objTypeParser.getValueOf("RightString");
								}
								
								WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Updated objTypeId : "+ objectTypeId +", ObjectTypeName : "+ objectTypeName + ", isObjList : " + isObjList);
								
								if(isObjList){
									//If this is a list type, then insert the data into WFUserObjAssocTable with actual objIDs.
									int batchCount = 0;
									String objectIdListStr = objTypeParser.getValueOf("ObjectIdList");
									XMLParser objListParser = new XMLParser(objectIdListStr);
									int noOfObj = objListParser.getNoOfFields("Object");
									WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : ObjectType objTypeId : "+ objectTypeId +", noOfObj : " + noOfObj);
									
									if(noOfObj > 0){
										query = "Insert into WFUserObjAssocTable(ObjectId, ObjectTypeId, UserId, AssociationType, ProfileId, AssignedTillDateTime, "
												+ "AssociationFlag,RightString,Filter) values(?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(assignedTillDateTime, true, dbType) + ", ?, ?, ?)";
										pstmt = con.prepareStatement(query);
										
										query = "Insert into WFProfileObjTypeTable (userid, ObjectTypeId, RightString, Associationtype, Filter) values (?, ?, ?, ?, ?)";
										pstmt1 = con.prepareStatement(query);
										
										Set<String> objTypeRightStringList = new HashSet<String>();
										//Delete the old records before actually inserting the updated records
										if(groupExists){
											query = "Delete from WFProfileObjTypeTable where userid = ? AND ObjectTypeId = ? and Associationtype = ?";
											stmt = con.prepareStatement(query);
											stmt.setInt(1, newGroupId);
											stmt.setInt(2, objectTypeId);
											stmt.setInt(3, 1);
											stmt.executeUpdate();
											stmt.close();
											stmt = null;
										}
										
										for(int ix = 0; ix < noOfObj; ix++){
											String objectStr = ((ix > 0) ? objListParser.getNextValueOf("Object") : objListParser.getFirstValueOf("Object"));
											XMLParser objParser = new XMLParser(objectStr);
											String objectIdStr = objParser.getValueOf("ObjectId");
											int objectId = Integer.parseInt(objectIdStr);
											String objectName = objParser.getValueOf("ObjectName");
											String rightStringForObject = objParser.getValueOf("RightString");
											
											if(objectName != null && !objectName.isEmpty()){
												
												//Get the ObjId of this object from the target cabinet.
												int updatedObjId = getObjIdForObjName(con, objectTypeId, objectName, dbType, engine, -1);
												if(updatedObjId > 0){
													//Delete the old records if any for the given combination
													if(groupExists){
														query = "delete from WFUserObjAssocTable where ObjectId = ? and ObjectTypeId = ? and UserId = ? and AssociationType = 1 and ProfileId = 0";
														stmt = con.prepareStatement(query);
														stmt.setInt(1, updatedObjId);
														stmt.setInt(2, objectTypeId);
														stmt.setInt(3, newGroupId);
														stmt.executeUpdate();
														stmt.close();
														stmt = null;
													}
													
													pstmt.setInt(1, updatedObjId);
													pstmt.setInt(2, objectTypeId);
													pstmt.setInt(3, newGroupId);
													pstmt.setInt(4, 1);		//Since this is for group, so association type is 1
													pstmt.setInt(5, 0);		//Profile ID will be zero for direct assignment on groups
													pstmt.setNull(6, java.sql.Types.VARCHAR);
													pstmt.setString(7, rightStringForObject);
													pstmt.setNull(8, java.sql.Types.VARCHAR);
													pstmt.addBatch();
													batchCount++;
													successObjList.append(generateOutputLogInfo(objectId, objectName, "Object Rights synced with source cabinet for the object : " + objectName, WFSConstant.WF_SUCCESS));
													
													//This will insert the entries into ProfileObjTypeTable if a group 
													//has multiple rights on the same object type with different set of rights.
													if(!objTypeRightStringList.contains(rightStringForObject)){
														pstmt1.setInt(1, newGroupId);
														pstmt1.setInt(2, objectTypeId);
														pstmt1.setString(3, rightString);
														pstmt1.setInt(4, 1);
														pstmt1.setNull(5, java.sql.Types.VARCHAR);
														pstmt1.addBatch();
														objTypeRightStringList.add(rightStringForObject);
													}
												}else{
													warningObjList.append(generateOutputLogInfo(oldGroupId, groupName, "Object not found on the target cabinet : " + objectName, WFSConstant.WF_WARNING));
													continue;
												}
											}else{
												warningObjList.append(generateOutputLogInfo(oldGroupId, groupName, "Object Name parameter not provided for ObjectId : " + objectId, WFSConstant.WF_WARNING));
												continue;
											}
										}
										if(batchCount > 0){
											pstmt.executeBatch();
											pstmt1.executeBatch();
											successObjList.append(generateOutputLogInfo(objectTypeId, objectTypeName, "ObjectType Rights synced with source cabinet for the object Type : " + objectTypeName, WFSConstant.WF_SUCCESS));
										}
										if(pstmt != null){
											pstmt.close();
											pstmt = null;
										}
										if(pstmt1 != null){
											pstmt1.close();
											pstmt1 = null;
										}
									}else{
										WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : No objects associated with this object type for this group : " + groupName);
									}
								}else{
									//Delete the old records before actually inserting the updated records
									if(groupExists){
										query = "Delete from WFProfileObjTypeTable where userid = ? AND ObjectTypeId = ? and Associationtype = ?";
										stmt = con.prepareStatement(query);
										stmt.setInt(1, newGroupId);
										stmt.setInt(2, objectTypeId);
										stmt.setInt(3, 1);
										stmt.executeUpdate();
										stmt.close();
										stmt = null;
									}
									
									//Insert data into WFProfileObjTypeTable for each association of objType and Group
									query = "Insert into WFProfileObjTypeTable (userid, ObjectTypeId, RightString, Associationtype, Filter) values (?, ?, ?, ?, ?)";
									pstmt = con.prepareStatement(query);
									pstmt.setInt(1, newGroupId);
									pstmt.setInt(2, objectTypeId);
									pstmt.setString(3, rightString);
									pstmt.setInt(4, 1);
									pstmt.setNull(5, java.sql.Types.VARCHAR);
									pstmt.executeUpdate();
									
									if(pstmt != null){
										pstmt.close();
										pstmt = null;
									}
									
									//Delete the old records if any for the given combination
									if(groupExists){
										query = "delete from WFUserObjAssocTable where ObjectId = ? and ObjectTypeId = ? and UserId = ? and AssociationType = 1 and ProfileId = 0";
										pstmt = con.prepareStatement(query);
										pstmt.setInt(1, -1);
										pstmt.setInt(2, objectTypeId);
										pstmt.setInt(3, newGroupId);
										pstmt.executeUpdate();
										pstmt.close();
										pstmt = null;
									}
									
									//If this is not an object list, then do entry with ObjectID -1 for this user and Non tree Object Type
									query = "Insert into WFUserObjAssocTable(ObjectId, ObjectTypeId, UserId, AssociationType, ProfileId, AssignedTillDateTime, "
											+ "AssociationFlag,RightString,Filter) values(?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(assignedTillDateTime, true, dbType) + ", ?, ?, ?)";
									pstmt = con.prepareStatement(query);
									pstmt.setInt(1, -1);
									pstmt.setInt(2, objectTypeId);
									pstmt.setInt(3, newGroupId);
									pstmt.setInt(4, 1);		//Since this is for group, so association type is 1
									pstmt.setInt(5, 0);		//Profile ID will be zero for direct assignment on groups
									pstmt.setNull(6, java.sql.Types.VARCHAR);
									pstmt.setString(7, rightString);
									pstmt.setNull(8, java.sql.Types.VARCHAR);
									pstmt.executeUpdate();
									
									if(pstmt != null){
										pstmt.close();
										pstmt = null;
									}
									successObjList.append(generateOutputLogInfo(objectTypeId, objectTypeName, "ObjectType Rights synced with source cabinet for the object Type", WFSConstant.WF_SUCCESS));
								}
							}
						}else{
							WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : No ObjTypeIds are associated with the group : groupName " + groupName);
						}
						WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Movement of direct rights completed for the group : " + groupName);
					}else{
						failedObjList.append(generateOutputLogInfo(oldGroupId, groupName, "Could not retrieve the Group ObjectType association data", WFSConstant.WF_FAILED));
						WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Could not retrieve the Group ObjectType association data, skipping : " + groupName);
					}
		        }else{
		            String omniDocsError = tmpParser.getValueOf("Error");
					failedObjList.append(generateOutputLogInfo(newGroupId, groupName, omniDocsError, WFSConstant.WF_FAILED));
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Error occurred while Creating/Updating the basic group property : " + omniDocsError);
		        	throw new WFSException(Integer.parseInt(status), 0, WFSError.WF_TMP, omniDocsError, null);
		        }
				successObjList.append(generateOutputLogInfo(oldGroupId, groupName, "Group synced with source cabinet : " + groupName, WFSConstant.WF_SUCCESS));
	        }else{
	            String omniDocsError = tmpParser.getValueOf("Error");
				failedObjList.append(generateOutputLogInfo(oldGroupId, groupName, omniDocsError, WFSConstant.WF_FAILED));
				WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Error occurred while fetching the basic group property (NGOGetGroupProperty) : " + omniDocsError);
	        	throw new WFSException(Integer.parseInt(status), 0, WFSError.WF_TMP, omniDocsError, null);
	        }
			WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Completed migration of group : "+ groupName);
		}finally{
			try{
			if(rs != null){
				rs.close();
				rs = null;
			}}catch(Exception e){
				WFRMSUtil.printErr(engine, e);
			}
			try{
			if(stmt != null){
				stmt.close();
				stmt = null;
			}}catch(Exception e){
				WFRMSUtil.printErr(engine, e);
			}
			try{
			if(stmt1 != null){
				stmt1.close();
				stmt1 = null;
			}}catch(Exception e){
				WFRMSUtil.printErr(engine, e);
			}
			try{
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}}catch(Exception e){
				WFRMSUtil.printErr(engine, e);
			}
		}
		WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Exiting WFMigrateGroupRightsData for group : " + groupName);
		return new String[]{successObjList.toString(), warningObjList.toString(), failedObjList.toString()};
	}

	
	
	public static String[] WFMigrateGroupRightsData(Connection con, int sessionId, int grpId, String engine, int dbType, 
			String localRestUrl,String overwriteProfileGroupPropertyAndRights, Map<String, Integer> objectTypeNameMap,String grpRightsObject,boolean groupExists,String groupName) throws Exception{
		StringBuffer apiInputXml = new StringBuffer();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String query = "";
		StringBuilder failedObjList = new StringBuilder();
		StringBuilder successObjList = new StringBuilder();
		try{
				if(groupExists && !"Y".equalsIgnoreCase(overwriteProfileGroupPropertyAndRights)){
					return new String[]{successObjList.toString(), failedObjList.toString()};
				}
				if(grpRightsObject!=null &&! grpRightsObject.trim().isEmpty()){
					XMLParser parser=new XMLParser(grpRightsObject);
					
					//Get the list of already associated objectTypes with the group:
					Set<Integer> associatedObjTypesList = new HashSet<Integer>();
					query = "select distinct ObjectTypeId from WFProfileObjTypeTable "+ WFSUtil.getTableLockHintStr(dbType) +" where UserId = ? and AssociationType = 1";
					pstmt = con.prepareStatement(query);
					pstmt.setInt(1, grpId);
					rs = pstmt.executeQuery();
					while(rs.next()){
						int associatedObjTypeId = rs.getInt("ObjectTypeId");
						associatedObjTypesList.add(associatedObjTypeId);
					}
					if(rs != null){
						rs.close();
						rs = null;
					}
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : GroupName:" + groupName+" Rights Object : "+grpRightsObject);
					XMLParser parser1=new XMLParser(grpRightsObject);
					
					String objectTypes = parser1.getValueOf("ObjectTypes");
					XMLParser tmpParser=new XMLParser(objectTypes);
					int noOfAssociatedObjTypes = tmpParser.getNoOfFields("ObjectType");
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : noOfAssociatedObjTypes with the group : " + noOfAssociatedObjTypes);
						
					if(noOfAssociatedObjTypes > 0){
						for(int inx = 0; inx < noOfAssociatedObjTypes; inx++){
							String objectType = ((inx > 0) ? tmpParser.getNextValueOf("ObjectType") : tmpParser.getFirstValueOf("ObjectType"));
							XMLParser objTypeParser = new XMLParser(objectType);
								
							String objectTypeName = objTypeParser.getValueOf("ObjectTypeName");
							int objectTypeId = objectTypeNameMap.get(objectTypeName.trim().toUpperCase());
								
							boolean isObjList = "Y".equalsIgnoreCase(objTypeParser.getValueOf("IsObjList"));
							String assignedTillDateTime = objTypeParser.getValueOf("AssignedTillDateTime");
							String rightString = WFSConstant.CONST_DEFAULT_RIGHTSTR_ZERO;
							if(!isObjList){
								rightString = objTypeParser.getValueOf("RightString");
							}
								
							WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Updated objTypeId : "+ objectTypeId +", ObjectTypeName : "+ objectTypeName + ", isObjList : " + isObjList);
							
							if(isObjList){
								//If this is a list type, then insert the data into WFUserObjAssocTable with actual objIDs.
								int batchCount = 0;
								String objectIdListStr = objTypeParser.getValueOf("ObjectIdList");
								XMLParser objListParser = new XMLParser(objectIdListStr);
								int noOfObj = objListParser.getNoOfFields("Object");
								WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : ObjectType objTypeId : "+ objectTypeId +", noOfObj : " + noOfObj);
									
								if(noOfObj > 0){
									query = "Insert into WFUserObjAssocTable(ObjectId, ObjectTypeId, UserId, AssociationType, ProfileId, AssignedTillDateTime, "
												+ "AssociationFlag,RightString,Filter) values(?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(assignedTillDateTime, true, dbType) + ", ?, ?, ?)";
									pstmt = con.prepareStatement(query);
										
									query = "Insert into WFProfileObjTypeTable (userid, ObjectTypeId, RightString, Associationtype, Filter) values (?, ?, ?, ?, ?)";
									pstmt1 = con.prepareStatement(query);
										
									Set<String> objTypeRightStringList = new HashSet<String>();
									//Delete the old records before actually inserting the updated records
									if(groupExists){
										query = "Delete from WFProfileObjTypeTable where userid = ? AND ObjectTypeId = ? and Associationtype = ?";
										stmt = con.prepareStatement(query);
										stmt.setInt(1, grpId);
										stmt.setInt(2, objectTypeId);
										stmt.setInt(3, 1);
										stmt.executeUpdate();
										if(stmt!=null){
											stmt.close();
											stmt = null;
										}
									}
										
									for(int ix = 0; ix < noOfObj; ix++){
										String objectStr = ((ix > 0) ? objListParser.getNextValueOf("Object") : objListParser.getFirstValueOf("Object"));
										XMLParser objParser = new XMLParser(objectStr);
										String objectName = objParser.getValueOf("ObjectName");
										String rightStringForObject = objParser.getValueOf("RightString");
											
										if(objectName != null && !objectName.isEmpty()){
												
											//Get the ObjId of this object from the target cabinet.
											int updatedObjId = getObjIdForObjName(con, objectTypeId, objectName, dbType, engine, -1);
											if(updatedObjId > 0){
												//Delete the old records if any for the given combination
												if(groupExists){
													query = "delete from WFUserObjAssocTable where ObjectId = ? and ObjectTypeId = ? and UserId = ? and AssociationType = 1 and ProfileId = 0";
													stmt = con.prepareStatement(query);
													stmt.setInt(1, updatedObjId);
													stmt.setInt(2, objectTypeId);
													stmt.setInt(3, grpId);
													stmt.executeUpdate();
													if(stmt!=null){
														stmt.close();
														stmt = null;
													}
												}
													
												pstmt.setInt(1, updatedObjId);
												pstmt.setInt(2, objectTypeId);
												pstmt.setInt(3, grpId);
												pstmt.setInt(4, 1);		//Since this is for group, so association type is 1
												pstmt.setInt(5, 0);		//Profile ID will be zero for direct assignment on groups
												pstmt.setNull(6, java.sql.Types.VARCHAR);
												pstmt.setString(7, rightStringForObject);
												pstmt.setNull(8, java.sql.Types.VARCHAR);
												pstmt.addBatch();
												batchCount++;
												successObjList.append("<GroupRights>");
												successObjList.append("<GroupName>").append(groupName).append("</GroupName>");
												successObjList.append("<ObjectTypeName>").append(objectTypeName).append("</ObjectTypeName>");
												successObjList.append("<Object>").append(objectName).append("</Object>");
												successObjList.append("<Info>").append("Object Rights synced on destination cabinet with source cabinet for the object : " + objectName).append("</Info>");
												successObjList.append("</GroupRights>");
													
												//This will insert the entries into ProfileObjTypeTable if a group 
												//has multiple rights on the same object type with different set of rights.
												if(!objTypeRightStringList.contains(rightStringForObject)){
													pstmt1.setInt(1, grpId);
													pstmt1.setInt(2, objectTypeId);
													pstmt1.setString(3, rightString);
													pstmt1.setInt(4, 1);
													pstmt1.setNull(5, java.sql.Types.VARCHAR);
													pstmt1.addBatch();
													objTypeRightStringList.add(rightStringForObject);
												}
											}else{
												failedObjList.append("<GroupRights>");
												failedObjList.append("<GroupName>").append(groupName).append("</GroupName>");
												failedObjList.append("<ObjectTypeName>").append(objectTypeName).append("</ObjectTypeName>");
												failedObjList.append("<Object>").append(objectName).append("</Object>");
												failedObjList.append("<Reason>").append("Object not found on destination cabinet : "+ engine).append("</Reason>");
												failedObjList.append("</GroupRights>");
												continue;
											}
										}else{
											failedObjList.append("<GroupRights>");
											failedObjList.append("<GroupName>").append(groupName).append("</GroupName>");
											failedObjList.append("<ObjectTypeName>").append(objectTypeName).append("</ObjectTypeName>");
											failedObjList.append("<Object>").append(objectName).append("</Object>");
											failedObjList.append("<Reason>").append("Object Name should not be empty or blank").append("</Reason>");
											failedObjList.append("</GroupRights>");
											continue;
										}
									}
									if(batchCount > 0){
										pstmt.executeBatch();
										pstmt1.executeBatch();
										successObjList.append("<GroupRights>");
										successObjList.append("<GroupName>").append(groupName).append("</GroupName>");
										successObjList.append("<ObjectTypeName>").append(objectTypeName).append("</ObjectTypeName>");
										successObjList.append("<Object>").append("").append("</Object>");
										successObjList.append("<Info>").append("ObjectType Rights synced on destination cabinet with source cabinet for the object Type : " + objectTypeName+ " and object types already associated .").append("</Info>");
										successObjList.append("</GroupRights>");
										
									}
									if(pstmt != null){
										pstmt.close();
										pstmt = null;
									}
									if(pstmt1 != null){
										pstmt1.close();
										pstmt1 = null;
									}
								}else{
									WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : No objects associated with this object type for this group : " + groupName);
								}
							}else{
								//Delete the old records before actually inserting the updated records
								if(groupExists){
									query = "Delete from WFProfileObjTypeTable where userid = ? AND ObjectTypeId = ? and Associationtype = ?";
									stmt = con.prepareStatement(query);
									stmt.setInt(1, grpId);
									stmt.setInt(2, objectTypeId);
									stmt.setInt(3, 1);
									stmt.executeUpdate();
									stmt.close();
									stmt = null;
								}
									
								//Insert data into WFProfileObjTypeTable for each association of objType and Group
								query = "Insert into WFProfileObjTypeTable (userid, ObjectTypeId, RightString, Associationtype, Filter) values (?, ?, ?, ?, ?)";
								pstmt = con.prepareStatement(query);
								pstmt.setInt(1, grpId);
								pstmt.setInt(2, objectTypeId);
								pstmt.setString(3, rightString);
								pstmt.setInt(4, 1);
								pstmt.setNull(5, java.sql.Types.VARCHAR);
								pstmt.executeUpdate();
									
								if(pstmt != null){
									pstmt.close();
									pstmt = null;
								}
									
								//Delete the old records if any for the given combination
								if(groupExists){
									query = "delete from WFUserObjAssocTable where ObjectId = ? and ObjectTypeId = ? and UserId = ? and AssociationType = 1 and ProfileId = 0";
									pstmt = con.prepareStatement(query);
									pstmt.setInt(1, -1);
									pstmt.setInt(2, objectTypeId);
									pstmt.setInt(3, grpId);
									pstmt.executeUpdate();
									if(pstmt != null){
										pstmt.close();
										pstmt = null;
									}
								}
									
								//If this is not an object list, then do entry with ObjectID -1 for this user and Non tree Object Type
								query = "Insert into WFUserObjAssocTable(ObjectId, ObjectTypeId, UserId, AssociationType, ProfileId, AssignedTillDateTime, "
											+ "AssociationFlag,RightString,Filter) values(?, ?, ?, ?, ?, " + WFSUtil.TO_DATE(assignedTillDateTime, true, dbType) + ", ?, ?, ?)";
								pstmt = con.prepareStatement(query);
								pstmt.setInt(1, -1);
								pstmt.setInt(2, objectTypeId);
								pstmt.setInt(3, grpId);
								pstmt.setInt(4, 1);		//Since this is for group, so association type is 1
								pstmt.setInt(5, 0);		//Profile ID will be zero for direct assignment on groups
								pstmt.setNull(6, java.sql.Types.VARCHAR);
								pstmt.setString(7, rightString);
								pstmt.setNull(8, java.sql.Types.VARCHAR);
								pstmt.executeUpdate();
									
								if(pstmt != null){
									pstmt.close();
									pstmt = null;
								}
								successObjList.append("<GroupRights>");
								successObjList.append("<GroupName>").append(groupName).append("</GroupName>");
								successObjList.append("<ObjectTypeName>").append(objectTypeName).append("</ObjectTypeName>");
								successObjList.append("<Object>").append("").append("</Object>");
								successObjList.append("<Info>").append("ObjectType Rights synced on destination cabinet with source cabinet for the object Type : " + objectTypeName).append("</Info>");
								successObjList.append("</GroupRights>");
							}
						}
					}else{
						WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : No ObjTypeIds are associated with the group : groupName " + groupName);
					}
					WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Movement of direct rights completed for the group : " + groupName);
				}
			WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Completed migration of group : "+ groupName);
		}finally{
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}}catch(Exception e){
					WFRMSUtil.printErr(engine, e);
				}
				try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}}catch(Exception e){
					WFRMSUtil.printErr(engine, e);
				}
				try{
				if(pstmt1 != null){
					pstmt1.close();
					pstmt1 = null;
				}}catch(Exception e){
					WFRMSUtil.printErr(engine, e);
				}
				try{
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}}catch(Exception e){
					WFRMSUtil.printErr(engine, e);
				}		}
		WFRMSUtil.printOut(engine,"WFRMSUtil.WFMigrateAndSetRightsData : Exiting WFMigrateGroupRightsData for group : " + groupName);
		return new String[]{successObjList.toString(), failedObjList.toString()};
	}
	
	/**
	 * This method associates the newly created objects in the list object types.
	 * @param stmt
	 * @param dbType
	 * @param userId
	 * @param assocType
	 * @param objectId
	 * @param objectTypeId
	 * @param parentObjectId
	 * @param rightStr
	 * @param filterStr
	 * @param objOper
	 * @param engine
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	public static int associateObjectsWithUser(Connection con, int dbType, int userId, int assocType, int objectId, String objectType, 
			String rightStr,String filterStr, char objOper,String engine) throws SQLException, Exception {
		Statement stmt = null;
		ResultSet rs = null;
		int res = 0;
		StringBuffer qBuffer1 = new StringBuffer(100);
		StringBuffer qBuffer = new StringBuffer(100);
		StringBuffer qBuffer2 = new StringBuffer(100);
		int mainCode = -1;
		int objectTypeId = 0;
		try{
			WFSUtil.printOut(engine,"dbType >>" + dbType);
			WFSUtil.printOut(engine,"userId >>" + userId);
			WFSUtil.printOut(engine,"assocType >>" + assocType);
			WFSUtil.printOut(engine,"objectId >>" + objectId);
			WFSUtil.printOut(engine,"objectType >>" + objectType);
			WFSUtil.printOut(engine,"rightStr >>" + rightStr);
			WFSUtil.printOut(engine,"filterStr >>" + filterStr);
			WFSUtil.printOut(engine,"objOper >>" + objOper);
			WFSUtil.printOut(engine,"engine >>" + engine);
			
			String[] objectTypeStr = WFSUtil.getIdForName(con, dbType, objectType, "O");
			objectTypeId = Integer.parseInt(objectTypeStr[1]);
			WFSUtil.printOut(engine,"objectTypeId >>" + objectTypeId);
			stmt = con.createStatement();
			switch(objOper){
				case 'I':{
					rs = stmt.executeQuery("select 1 from WFProfileObjTypeTable where Userid = "+userId+" and AssociationType = 0 and ObjectTypeId = "+objectTypeId+"");
					if(!rs.next())
						qBuffer1.append("Insert into WFProfileObjTypeTable (Userid, AssociationType, ObjectTypeId, RightString, Filter) values ("+userId+", "+assocType+", "+objectTypeId+", " + WFSUtil.TO_STRING(rightStr, true, dbType) + ", "+WFSUtil.TO_STRING(filterStr, true, dbType)+")");
                    if(rs != null){
                        rs.close();
                        rs = null;
                    }
                    /*If AuthorizationFlag is Y then in case of addqueue Queueid will be 0 which is already in table there needs to restrict from insertion*/
                    //Bug 38207, Registered process rights are not returned
                    if(objectId == 0){
                        rs = stmt.executeQuery("select 1 from WFUserObjAssocTable where Userid = "+userId+" and AssociationType = 0 and ObjectTypeId = 2 and objectId = 0");
                        if(!rs.next())
                            qBuffer.append("Insert into WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId,  UserId, AssociationType, AssignedTillDateTime, AssociationFlag, RightString, Filter) values ("+objectId+", "+objectTypeId+", 0, " + userId + ", " + assocType + ", null, null, " + WFSUtil.TO_STRING(rightStr, true, dbType) + ", "+WFSUtil.TO_STRING(filterStr, true, dbType) + " )");
                    }else{
                        qBuffer.append("Insert into WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId,  UserId, AssociationType, AssignedTillDateTime, AssociationFlag, RightString, Filter) values ("+objectId+", "+objectTypeId+", 0, " + userId + ", " + assocType + ", null, null, " + WFSUtil.TO_STRING(rightStr, true, dbType) + ", "+WFSUtil.TO_STRING(filterStr, true, dbType) + " )");
                    }   
					break;
				}
				case 'D':{
					qBuffer.append("Delete WFUserObjAssocTable where UserId = "+userId+" and AssociationType = " +  assocType + " and ObjectId = "+objectId+" and ObjectTypeId = "+objectTypeId+"");
					break;
				}
				case 'U':{
					qBuffer.append("update WFProfileObjTypeTable set RightString = "+(rightStr.equals("") ? " NULL" : WFSUtil.TO_STRING(rightStr, true, dbType))+", Filter = "+(filterStr.equals("") ? " NULL" : WFSUtil.TO_STRING(filterStr, true, dbType))+" where UserId = "+userId+" and AssociationType = " + assocType + " and ObjectTypeId = "+objectTypeId+"");
					qBuffer2.append("update WFUserObjAssocTable set RightString = "+(rightStr.equals("") ? " NULL" : WFSUtil.TO_STRING(rightStr, true, dbType))+", Filter = "+(filterStr.equals("") ? " NULL" : WFSUtil.TO_STRING(filterStr, true, dbType))+" where UserId = "+userId+" and AssociationType = " + assocType + " and ObjectTypeId = "+objectTypeId+" and ObjectId = "+objectId+"");
					break;
				}
			}
			WFSUtil.printOut(engine,"Query created::"+qBuffer.toString());
            /*Bug 36519 fixed*/
            //in case of association of queues created after swimlane checkout if queueid is 0 it was throwing error
			if(qBuffer != null && !qBuffer.toString().trim().equals(""))
                res = stmt.executeUpdate(qBuffer.toString());
			if(qBuffer1 != null && !qBuffer1.toString().trim().equals("")){
				WFSUtil.printOut(engine,"Query created::"+qBuffer1.toString());
				res = stmt.executeUpdate(qBuffer1.toString());
			}	
			if(qBuffer2 != null && !qBuffer2.toString().trim().equals("")){
				WFSUtil.printOut(engine,"Query created::"+qBuffer2.toString());
				res = stmt.executeUpdate(qBuffer2.toString());
			}
			
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(stmt != null){
				stmt.close();
				stmt = null;
			}
			mainCode = 0;
		}catch(Exception ex){
			WFSUtil.printErr(engine,"", ex);
			WFSUtil.printErr(engine, ex.getMessage());
			mainCode = -1;
		}finally{
			try{
				if(stmt != null){
					stmt.close();
					stmt = null;
				}
			}catch(Exception ex){
				WFSUtil.printErr(engine,"", ex);
			}
			try{
				if(rs != null){
					rs.close();
					rs = null;
				}
			}catch(Exception ex){
				WFSUtil.printErr(engine,"", ex);
			}
		}
		return mainCode;
	}
	
	public static ArrayList filterProfileData(String inputXml,String engine, Set<Integer> processlist, Set<Integer> queuelist, Set<String> objectTypeNameList){
		ArrayList outputlist=new ArrayList<>();
		Set<Integer> groupList=new HashSet();
		try{
			XMLParser parser=new XMLParser(inputXml);
			StringBuffer output=new StringBuffer();
			
			String objectTypes = parser.getValueOf("ObjectTypes");
			XMLParser tmpParser1=new XMLParser(objectTypes);
			int noOfAssociatedObjTypes = tmpParser1.getNoOfFields("ObjectType");
			StringBuffer groupRights = new StringBuffer();
			WFRMSUtil.printOut(engine,"WFRMSUtil.filterProfileData : noOfAssociatedObjTypes with the group : " + noOfAssociatedObjTypes);
			groupRights.append("");
			if(noOfAssociatedObjTypes > 0){
				for(int inx = 0; inx < noOfAssociatedObjTypes; inx++){
					String objectType = ((inx > 0) ? tmpParser1.getNextValueOf("ObjectType") : tmpParser1.getFirstValueOf("ObjectType"));
					XMLParser objTypeParser = new XMLParser(objectType);
					String objectTypeName = objTypeParser.getValueOf("ObjectTypeName");
					if(processlist.size()>0 && ("Process Management".equalsIgnoreCase(objectTypeName) || "Queue Management".equalsIgnoreCase(objectTypeName)))
					{
						groupRights.append("<ObjectType>"+objectType+"</ObjectType>");
					}
					else if (objectTypeNameList.size()>0 && objectTypeNameList.contains(objectTypeName))
					{
						groupRights.append("<ObjectType>"+objectType+"</ObjectType>");
					}
				}
			}
			parser.changeValue("ObjectTypes", groupRights.toString());
			
			
			int count=parser.getNoOfFields("UserInfo");
			XMLParser parser1=new XMLParser();
			if(count>0){
				for(int i=0;i<count;i++){
					boolean addGroup = false;
					if(i==0){
						parser1.setInputXML(parser.getFirstValueOf("UserInfo"));
					}else{
						parser1.setInputXML(parser.getNextValueOf("UserInfo"));
					}
					int associationType=parser1.getIntOf("AssociationType", 0, true) ;
					if(associationType==1){
						int noOfAssociatedObjTypes1 = parser1.getNoOfFields("ObjectType");
						StringBuffer userInfo = new StringBuffer();
						WFRMSUtil.printOut(engine,"WFRMSUtil.filterProfileData : noOfAssociatedObjTypes with the group : " + noOfAssociatedObjTypes);
						if(noOfAssociatedObjTypes1 > 0){
							for(int inx = 0; inx < noOfAssociatedObjTypes1; inx++){
								String objectType = ((inx > 0) ? parser1.getNextValueOf("ObjectType") : parser1.getFirstValueOf("ObjectType"));
								XMLParser objTypeParser = new XMLParser(objectType);
								String assignableRights = objTypeParser.getValueOf("AssignableRights");
								String filters = objTypeParser.getValueOf("Filters", "", true);
								String objectTypeName = objTypeParser.getValueOf("ObjectTypeName");
								int objectTypeId = objTypeParser.getIntOf("ObjectTypeId", 0, false);
								String isObjList = objTypeParser.getValueOf("isObjList");
								if(processlist.size()>0 && ("Process Management".equalsIgnoreCase(objectTypeName) || "Queue Management".equalsIgnoreCase(objectTypeName)))
								{
									String objectIdListStr = objTypeParser.getValueOf("ObjectIdList");
									XMLParser objListParser = new XMLParser(objectIdListStr);
									int noOfObj = objListParser.getNoOfFields("Object");
									WFRMSUtil.printOut(engine,"WFRMSUtil.filterProfileData : ObjectType objTypeId : "+ objectTypeId +", noOfObj : " + noOfObj);
									userInfo.append("<ObjectType>"
											+ "<ObjectTypeId>"+objectTypeId+"</ObjectTypeId>"
											+ "<ObjectTypeName>"+objectTypeName+"</ObjectTypeName>"
											+ "<isObjList>"+isObjList+"</isObjList>");
									userInfo.append( "<ObjectIdList>");
									if(noOfObj > 0){
										for(int ix = 0; ix < noOfObj; ix++){
											String objectStr = ((ix > 0) ? objListParser.getNextValueOf("Object") : objListParser.getFirstValueOf("Object"));
											XMLParser objParser = new XMLParser(objectStr);
											int objectID = objParser.getIntOf("ObjectId", 0, false);
											if("Process Management".equalsIgnoreCase(objectTypeName))
											{
												if(processlist.size()>0 && processlist.contains(objectID))
												{
													userInfo.append("<Object>"+objectStr+"</Object>");
													addGroup = true;
												}
												
											}
											else
											{
												if(queuelist.size()>0 && queuelist.contains(objectID))
												{
													userInfo.append("<Object>"+objectStr+"</Object>");
													addGroup = true;
												}
												
											}
										}					
									}
									else{
										WFRMSUtil.printOut(engine,"WFRMSUtil.filterWFGetUserObjTypeAssociationOutput : No objects associated with this object type : "+objectTypeName );
									}	

									userInfo.append("</ObjectIdList>");
									userInfo.append("<AssignableRights>"+assignableRights+"</AssignableRights>");
									userInfo.append("<Filters>"+filters+"</Filters>");
									userInfo.append("</ObjectType>");	
								}
								else if (objectTypeNameList.size()>0 && objectTypeNameList.contains(objectTypeName))
								{
									userInfo.append("<ObjectType>"+objectType+"</ObjectType>");
									addGroup = true;
								}
							}
						}
						else {
							addGroup = true;
						}
						if(addGroup)
						{
							int groupId=parser1.getIntOf("ID", 0, true);
							String grpName = parser1.getValueOf("Name", "", true);
							output.append("<UserInfo>");
							output.append("<ID>"+groupId+"</ID>");
							output.append("<Name>"+grpName+"</Name>");
							output.append("<AssociationType>"+associationType+"</AssociationType>");
							output.append(userInfo);
							output.append("</UserInfo>");
							if(groupId!=0){
								groupList.add(groupId);
							}
						}
					}
				}
			}
			parser.changeValue("ProfileAssociation", output.toString());
			outputlist.add(parser.getValueOf("WFFetchProfileProperty_Output"));
			outputlist.add(groupList);
			
		}catch(Exception e){
			WFRMSUtil.printErr(engine, "", e);
			outputlist.add("");
			outputlist.add(groupList);
		}
		
		return outputlist;
	}
	
	public static String readBufferFromFile(String filePath) throws IOException{
		filePath=FilenameUtils.normalize(filePath);
		File inputFile = new File(filePath);
		byte[] fileContent = new byte[(int)inputFile.length()];
		FileInputStream fis = new FileInputStream(inputFile);
		int count=fis.read(fileContent);
		if(count<=0){
			WFRMSUtil.printOut("", "WFRMSUtil.readBufferFromFile:: count is zero");
		}
		fis.close();
		String encodedStr = EncodeImage.encodeImageData(fileContent).toString();
		return encodedStr;
	}
	
	public static List<Map<String, String>> populateDataFromXLS(HSSFSheet sheet,String engine,String sheetName){
		List<Map<String, String>> recordsList=new ArrayList<Map<String, String>> ();
		try{
			if(sheet!=null){
				WFRMSUtil.printOut(engine, "[populateDataFromXLS] Populating the  data for sheet : " + sheetName);
				Iterator rows = sheet.rowIterator();
				Map<Integer, String> columnHeader = new HashMap<Integer, String>();
				/** Escaping first row because its description in all sheet **/
				if(rows.hasNext()){
					rows.next();
				}
				int counter=0;
				/** Reading Column Header node because second row contain title **/
				if(rows.hasNext()){
					HSSFRow row = (HSSFRow) rows.next();
		            Iterator cells = row.cellIterator();
		             while (cells.hasNext()) {
		            	 HSSFCell cell = (HSSFCell) cells.next();
		                 String cellData = cell.toString().trim().toUpperCase();
		                 if(cellData != null && !cellData.isEmpty()){
			                  columnHeader.put(counter, cell.toString().trim().toUpperCase());
		                 }else{
		                    break;
		                 }
		                 counter++;
		             }
				}
				WFRMSUtil.printOut(engine, "[populateDataFromXLS] Column header populated succesfully !. No of columns : " + columnHeader.size());
				
				if(columnHeader.size()>0){
					DataFormatter formatter = new DataFormatter();
					
					while (rows.hasNext()) {
						Map<String, String> recordsMap = new HashMap<String, String>();
						HSSFRow row = (HSSFRow) rows.next();
						boolean blankRecord = true;
						for(int columnCounter = 0; columnCounter < columnHeader.size(); columnCounter++){
							Cell cell = row.getCell(columnCounter, org.apache.poi.ss.usermodel.Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
							String columnName = columnHeader.get(columnCounter);
							String cellData = "";
							if(cell != null && !cell.toString().trim().isEmpty()){
								blankRecord = false;
								if("EXPIRYDATE(DD/MM/YYYY)".equalsIgnoreCase(columnName)){
									Date date=cell.getDateCellValue();
									SimpleDateFormat format=new SimpleDateFormat("YYYY-MM-dd");
									cellData=format.format(date);
								}else{
									cellData = formatter.formatCellValue(cell);
								}
							}
							recordsMap.put(columnName, cellData);
						}
						if(!blankRecord){
							recordsList.add(recordsMap);
						}else{
							break;
						}
					}
				}
				WFRMSUtil.printOut(engine, "[populateDataFromXLS] Records data populated successfully!, No of records : " + recordsList.size());
			}
		}catch(Exception e){
			WFRMSUtil.printErr("", "Some error occur during reading  data from XLS User Sheet " , e);
		}
		return recordsList;
	}

	public static String getCheckSum(MessageDigest digest, String message) throws IOException
	{
		//InputStream inputStream=null;
		StringBuffer checkSum=new StringBuffer();
		try{
//			inputStream=IOUtils.toInputStream(message);
//			byte[] byteArray = new byte[1024];
//			int bytesCount = 0; 
//			while ((bytesCount = inputStream.read(byteArray)) != -1) 
//			{
//				digest.update(byteArray, 0, bytesCount);
//			}
			if(message!=null){
				byte[] byteArray =message.getBytes(WFSConstant.CONST_ENCODING_UTF8);
				digest.update(byteArray, 0, byteArray.length);
				byte[] bytes = digest.digest();
				
				for(int i=0; i< bytes.length ;i++)
				{
					checkSum.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
				}
			}
		}finally{
			
		}
	   return checkSum.toString();
	}
	public static String[] verifyXMLBuffer(HSSFSheet sheet,String engine,String sheetName){
		String[] recordsList=new String[2];
		try{
			recordsList[0]="false";
			recordsList[1]="";
			if(sheet!=null){
				WFRMSUtil.printOut(engine, "[verifyXMLBuffer] Populating the  data for sheet : " + sheetName);
				Iterator rows = sheet.rowIterator();
				if(rows.hasNext()){
					rows.next();
				}
				if(rows.hasNext()){
					rows.next();
				}
				DataFormatter formatter = new DataFormatter();
					
				if (rows.hasNext()) {
					HSSFRow row = (HSSFRow) rows.next();
					Cell cell = row.getCell(0, org.apache.poi.ss.usermodel.Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
					int count=0;
					String xmlBuffer = "";
					if(cell != null && !cell.toString().trim().isEmpty()){
						count = Integer.parseInt(formatter.formatCellValue(cell));
					}
					cell = row.getCell(1, org.apache.poi.ss.usermodel.Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
					String checkSum = "";
					if(cell != null && !cell.toString().trim().isEmpty()){
						checkSum = formatter.formatCellValue(cell);
					}
					
					if(count>0){						
						for(int i=0;i<count;i++){
							if(rows.hasNext()){
								row = (HSSFRow) rows.next();
								cell = row.getCell(0, org.apache.poi.ss.usermodel.Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
								String data = "";
								if(cell != null && !cell.toString().trim().isEmpty()){
									data = formatter.formatCellValue(cell);
								}
								if(data!=null && data.length()>0){
									xmlBuffer+=data;
								}else{
									break;
								}
							}else{
								break;
							}
						}
					}
					WFRMSUtil.printOut(engine, "Verify xml Buffer: "+xmlBuffer);
					MessageDigest md5Digest = MessageDigest.getInstance("MD5");
					String newCheckSum=WFRMSUtil.getCheckSum(md5Digest,xmlBuffer);
					if(newCheckSum!=null && newCheckSum.equals(checkSum)){
						recordsList[0]="true";
						recordsList[1]=xmlBuffer;
					}
				}
			}
		}catch(Exception e){
			WFRMSUtil.printErr(engine, "Some error occur during reading  data from XLS User Sheet " , e);
		}
		return recordsList;
	}
	
	
	//Method to filter the rights of groups for bug Id-104900 
		public static StringBuffer filterWFGetUserObjTypeAssociationOutput(String engine, XMLParser tmpParser, Set<Integer> processlist, Set<Integer> queuelist, Set<String> objectTypeNameList) throws JTSException {
			String objectTypes = tmpParser.getValueOf("ObjectTypes");
			XMLParser tmpParser1=new XMLParser(objectTypes);
			int noOfAssociatedObjTypes = tmpParser1.getNoOfFields("ObjectType");
			StringBuffer groupRights = new StringBuffer();
			WFRMSUtil.printOut(engine,"WFRMSUtil.filterWFGetUserObjTypeAssociationOutput : noOfAssociatedObjTypes with the group : " + noOfAssociatedObjTypes);
			groupRights.append("<ObjectTypes>");
			if(noOfAssociatedObjTypes > 0){
				for(int inx = 0; inx < noOfAssociatedObjTypes; inx++){
					String objectType = ((inx > 0) ? tmpParser1.getNextValueOf("ObjectType") : tmpParser1.getFirstValueOf("ObjectType"));
					XMLParser objTypeParser = new XMLParser(objectType);
					String assignableRights = objTypeParser.getValueOf("AssignableRights");
					String filters = objTypeParser.getValueOf("Filters", "", true);
					String objectTypeName = objTypeParser.getValueOf("ObjectTypeName");
					int objectTypeId = objTypeParser.getIntOf("ObjectTypeId", 0, false);
					String isObjList = objTypeParser.getValueOf("isObjList");
					if("Process Management".equalsIgnoreCase(objectTypeName) || "Queue Management".equalsIgnoreCase(objectTypeName))
					{
						String objectIdListStr = objTypeParser.getValueOf("ObjectIdList");
						XMLParser objListParser = new XMLParser(objectIdListStr);
						int noOfObj = objListParser.getNoOfFields("Object");
						WFRMSUtil.printOut(engine,"WFRMSUtil.filterWFGetUserObjTypeAssociationOutput : ObjectType objTypeId : "+ objectTypeId +", noOfObj : " + noOfObj);
						groupRights.append("<ObjectType>"
								+ "<ObjectTypeId>"+objectTypeId+"</ObjectTypeId>"
								+ "<ObjectTypeName>"+objectTypeName+"</ObjectTypeName>"
								+ "<isObjList>"+isObjList+"</isObjList>");
						groupRights.append( "<ObjectIdList>");
						if(noOfObj > 0){
							for(int ix = 0; ix < noOfObj; ix++){
								String objectStr = ((ix > 0) ? objListParser.getNextValueOf("Object") : objListParser.getFirstValueOf("Object"));
								XMLParser objParser = new XMLParser(objectStr);
								int objectID = objParser.getIntOf("ObjectId", 0, false);
								if("Process Management".equalsIgnoreCase(objectTypeName))
								{
									if(processlist.size()>0 && processlist.contains(objectID))
									{
										groupRights.append("<Object>"+objectStr+"</Object>");
									}
									
								}
								else
								{
									if(queuelist.size()>0 && queuelist.contains(objectID))
									{
										groupRights.append("<Object>"+objectStr+"</Object>");
									}
									
								}
							}				
						}
						else{
							WFRMSUtil.printOut(engine,"WFRMSUtil.filterWFGetUserObjTypeAssociationOutput : No objects associated with this object type : "+objectTypeName );
						}
						groupRights.append("</ObjectIdList>");
						groupRights.append("<AssignableRights>"+assignableRights+"</AssignableRights>");
						groupRights.append("<Filters>"+filters+"</Filters>");
						groupRights.append("</ObjectType>");		
					}
					else if (objectTypeNameList.size()>0 && objectTypeNameList.contains(objectTypeName))
					{
						groupRights.append("<ObjectType>"+objectType+"</ObjectType>");
					}
				}
			}
			groupRights.append("</ObjectTypes>");
			return groupRights;
		}

		
}
