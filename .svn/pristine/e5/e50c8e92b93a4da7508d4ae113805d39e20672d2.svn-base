// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application ?Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFExceptionClass.java
//	Author					: Prashant
//	Date written(DD/MM/YYYY): 16/05/2002
//	Description				: Implementation of Exception External Interface.
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date	                Change By               Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// -------------------------------------------------------------------------------------------------
// 01/10/2002		Prashant		Set Exception irrespective of the Association on the activity
// 26/11/2002		Prashant		Bug No OF_BUG_6
// 26/03/2003		Prashant		Bug No TSR_3.0.1_026
// 31/05/2004		Krishan			Bug No WSE_5.0.1_002
// 08/09/2004		Krishan			wfs_5_001 (For removing JMS)
// 18/05/2005           Ashish Mangla	        Changes for automatic cache updation
// 02/02/2006		Ashish Mangla	        WFS_6.1_045 Exception Status not cleared for the workitem correctly in distribut case
// 14/07/2006		Ashish Mangla	        WFS_6.1.2_070 Exception not seen at Exit workstep(query workstep after transferdata)
// 22/01/2007		Varun Bhansaly          Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
// 05/06/2007           Ruhi Hira               WFS_5_161, MultiLingual Support (Inherited from 5.0).
// 05/09/2007           Shilpi S                SrNo-1 , Omniflow7.1 feature, multiple exception raise and clear on activity
// 18/10/2007		Varun Bhansaly	        SrNo-2, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
// 19/11/2007		Varun Bhansaly	        WFSUtil.readLargeString() should be avoided.
// 23/11/2007           Shilpi S                Bug#1773
// 25/01/2008       Varun Bhansaly              Bugzilla Id 1719
// 21/07/2008       Shilpi S                Bugzilla Id 5817
// 15/04/2009       Shilpi Srivastava       SrNo-3, OFME Support 
// 01/07/2009       Saurabh Kamal		    SrNo-4, do not append speacial character in case of no trigger is associated.
// 13/08/2009		Saurabh Kamal			Change in SetExternalData for Response,Reject and Clear operation
// 24/08/2009		Saurabh Kamal			Bugzilla Id 10384--Mutiple Attribute tag should be there for One Exception having multiple operation type.
// 27/08/2009		Saurabh Kamal			Bugzilla Id 10394 (While clearing an exception duplicate entries are getting inserted in ExceptionTable.)	
// 10/09/2009		Saurabh Kamal			Bugzilla Id 10600 (New line character is there within Attribute closing tag)
// 04/11/2009       Prateek Verma           Bug Id WFS_8.0_051. New Functions added for setting Exception Interface Association with an activity and ExceptionMetadata.(Requirement)
// 02/09/2011		Shweta Singhal	 		Change for SQL Injection.
// 17/05/2012		Bhavneet Kaur			Bug 31982- Clear Exception Trigger not getting executed when specified in Entry Setting of a workstep
// 05/07/2012       Bhavneet Kaur   		Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//	31/10/2012		Preeti Awasthi			Bug 36247 - Exception occurred in SetExternalData is ignored due to which if InstrumentStatus is not updated and routing gets effected.
//  21/12/2013		Kahkeshan				Code Optimization Changes For setExternalData
//	01/05/2015		Mohnish Chopra			Changes for Case Management in getExternalData
//	04/04/2017		Kumar Kimil				Exception is getting raised but not getting responded or cleared when using the exception trigger
//  18/02/2021      Shubham Singla          Bug 98159 - iBPS 4.0 SP1:-Requirement to view the exception list by exception name .
//19/05/2021        Shubham Singla          Bug 99459 - iBPS 5.0+Oracle: Issue is coming while modifying any exception.
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.excp.WFSException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;

public class WFExceptionClass extends WFExternalInterface{

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WMGetException
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator , ProcessDefId , ActivityId  , ProcessInst, WorkItem
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        int taskId = parser.getIntOf("TaskId", 0, true);

        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
        /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
        String locale = parser.getValueOf("Locale");
		//SrNo-3
        boolean isPDAClient = parser.getValueOf("PDAFlag", "N", true).equalsIgnoreCase("Y");
        StringBuffer doctypXml = new StringBuffer(WFSConstant.WF_STRBUF);
        PreparedStatement pstmt = null;
        ResultSet rs = null;		
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        HashMap tempHash = new HashMap();
        String tempExcpIndex = null;

        try{
            int dbType = ServerProperty.getReference().getDBType(engine);
            int exp = 0;
            String filterStr = null;
            String localeParam = null;
            if(processDefId != 0 && activityId != 0){
                doctypXml.append("<ExceptionInterface>");
                if(defnflag == 'Y' || isCacheExpired(con, parser)){
                    doctypXml.append("<Definition>");
                    try{
                        /**
                         * LIMITATION :
                         * Case : two exceptions have been befined for ar-ly and ar-sa, now
                         * if user has set encoding as ar, in his/ her IE settings
                         * then he/ she should get description in english.
                         * In current code, the last row has been returned from server,
                         * that can be ANY OF ar-ly & ar-sa (inherited from Omniflow 5.0).
                         * Ideally this case should not be handled at server but at UI.
                         * Either a description from process modeler should be added for ar separately.
                         * OR
                         * User should select sepecific locale in IE.
                         * IE 7.0 and Microsoft .NET framework are compatible (give both language as well as country code)
                         * IE 6.0 does not give country code for some locales
                         * Hence this case is being handled at server with like query.
                         * As discussed with Mr. Ajay A, Mr. Dinesh P, Mr. KD Dixit, Ashish Mangla, Ankur Jain
                         * - Ruhi Hira
                         */
                        if(locale != null && locale.trim().length() > 0){
                            if(locale.indexOf("-") >= 0){
                                filterStr = TO_STRING("Locale", false, dbType) + " = ? ";
                                localeParam = locale.trim().toUpperCase();
                            } else {
                                filterStr = TO_STRING("Locale", false, dbType) + " like ? ";
                                localeParam = locale.trim().toUpperCase() + "%";
                            }
                            pstmt = con.prepareStatement("SELECT elementid, description "
                                                         + " FROM ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " ,InterfaceDescLanguageTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ActivityInterfaceAssocTable.ProcessDefId =InterfaceDescLanguageTable.ProcessDefId "
                                                         + " AND InterfaceDescLanguageTable.processdefid = ? "
                                                         + " AND ActivityInterfaceAssocTable.ActivityId = ? "
                                                         + " AND interfaceid = 4 "
                                                         + " AND InterfaceType ='E' "
                                                         + " AND ActivityInterfaceAssocTable.InterfaceElementId = elementid AND "
                                                         + filterStr
                                                         + " ORDER BY elementid ");
                            pstmt.setInt(1, processDefId);
                            pstmt.setInt(2, activityId);
                            WFSUtil.DB_SetString(3, localeParam, pstmt, dbType);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            while(rs.next()){
                                tempHash.put(rs.getString(1), rs.getString(2));
                            }
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;
                        }
                    } catch(SQLException e){
                        WFSUtil.printErr(engine,"", e);
                    } finally {
                        if(rs != null){
                            rs.close();
                            rs = null;
                        }
                        if(pstmt != null){
                            pstmt.close();
                            pstmt = null;
                        }
                    }

                    //SrNo-3    
                    String excpQueryString = "Select ExceptionId , ExceptionName , Description ,"
                                                 + " Attribute as Type , ActivityInterfaceAssocTable.TriggerName "
                                                 + " from ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " , ExceptionDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityInterfaceAssocTable.ProcessDefId = ExceptionDefTable.ProcessDefId "
                                                 + " and ExceptionDefTable.ProcessDefId = ? "
                                                 + " and ActivityInterfaceAssocTable.ActivityId = ? "
                                                 + " and InterfaceType ='E' "
                                                 + " and ActivityInterfaceAssocTable.InterfaceElementId = ExceptionId "
                                                 + " ORDER BY ExceptionName ";
                    if(isPDAClient){
                        excpQueryString = "Select ExceptionId , ExceptionName , Description ,"
                                                 + " Attribute as Type , ActivityInterfaceAssocTable.TriggerName "
                                                 + " from ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + "  , ExceptionDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  , WFPDATable " + WFSUtil.getTableLockHintStr(dbType)
                                                 + " where ActivityInterfaceAssocTable.ProcessDefId = ExceptionDefTable.ProcessDefId "
                                                 + " and ExceptionDefTable.ProcessDefId = ? "
                                                 + " and ActivityInterfaceAssocTable.ActivityId = ? "
                                                 + " and ActivityInterfaceAssocTable.InterfaceType ='E' "
                                                 + " and ActivityInterfaceAssocTable.InterfaceElementId = ExceptionId "
                                                 + " and WFPDATable.ProcessDefId = ExceptionDefTable.ProcessDefId "
                                                 + " and WFPDATable.ActivityId = ActivityInterfaceAssocTable.ActivityId"
                                                 + " and WFPDATable.InterfaceId = ExceptionDefTable.ExceptionId "
                                                 + " and WFPDATable.InterfaceType = 'E' "
                                                 + " ORDER BY ExceptionName ";
                    }
                    //Changes for Case Management
                    if(taskId>0){
                    	    excpQueryString = "Select ExceptionId , ExceptionName , Description ,"
                               + " a.Attribute as Type , b.TriggerName "
                               + " from WFRTTaskInterfaceAssocTable a "+ WFSUtil.getTableLockHintStr(dbType) + " inner join " 
                               + " ActivityInterfaceAssocTable b on a.processdefid= b.processdefid " 
                               + " and a.activityid=b.activityid and  a.interfaceid = b.interfaceelementid " 
                               + " and  a.interfacetype =b.interfacetype and a.attribute =b.attribute ,"
                               + " ExceptionDefTable "+ WFSUtil.getTableLockHintStr(dbType) 
                               + " where b.ProcessDefId = ExceptionDefTable.ProcessDefId "
                               + " and ExceptionDefTable.ProcessDefId = ? "
                               + " and b.ActivityId = ? "
                               + " and a.InterfaceType ='E' "
                               + " and a.InterfaceId = ExceptionId and a.processinstanceid = ? and a.workitemid= ? and a.taskid= ? "
                               + " ORDER BY ExceptionName ";
                    }
                    
                    
                    pstmt = con.prepareStatement(excpQueryString);
                    pstmt.setInt(1, processDefId);
                    pstmt.setInt(2, activityId);
                    if(taskId > 0 ){
                        pstmt.setString(3, processInst);
                        pstmt.setInt(4, workItem);
                        pstmt.setInt(5, taskId);

                    }
                    pstmt.execute();
                    rs = pstmt.getResultSet();				
					String trgr_name = "";
					int lastExcIndex = 0;
					boolean flag=false;
                    StringBuffer triggers = new StringBuffer();
                    doctypXml.append("<ExceptionDefs>\n");
					/*
					 * Changed By : Saurabh Kamal
					 * Changed On : 25 August 2009
					 * Description : Bugzilla Id 10384--Mutiple Attribute tag should be there for One Exception having multiple operation type.
					 */
                    while(rs.next()){
						tempExcpIndex = rs.getString(1);
						if(lastExcIndex != 0 && Integer.parseInt(tempExcpIndex) != lastExcIndex){
							doctypXml.append("</Attributes>\n");
							doctypXml.append("</ExceptionDef>\n");
						}                        
						if(Integer.parseInt(tempExcpIndex) != lastExcIndex){
							flag=true;
							doctypXml.append("<ExceptionDef>\n");
							//SrNo-1
							doctypXml.append(gen.writeValueOf("ExceptionDefIndex", tempExcpIndex));
							doctypXml.append(gen.writeValueOf("ExceptionDefName", rs.getString(2)));
							if(tempHash.containsKey(tempExcpIndex)){
								doctypXml.append(gen.writeValueOf("Description", tempHash.get(tempExcpIndex).toString()));
							} else{
								doctypXml.append(gen.writeValueOf("Description", rs.getString(3)));
							}
							doctypXml.append("<Attributes>\n");
							doctypXml.append("<Attribute>\n");
							doctypXml.append(gen.writeValueOf("Type", rs.getString(4)));
							trgr_name = rs.getString(5);
							//SrNo-4
							if(trgr_name != null && !trgr_name.equals("")){
								trgr_name = !rs.wasNull() ? "�" + trgr_name + "�" : "";
							}
							doctypXml.append(trgr_name);
							triggers.append(trgr_name);
							doctypXml.append("</Attribute>\n");
						}else{
							doctypXml.append("<Attribute>\n");
							doctypXml.append(gen.writeValueOf("Type", rs.getString(4)));
							trgr_name = rs.getString(5);
							//SrNo-4
							if(trgr_name != null && !trgr_name.equals("")){
								trgr_name = !rs.wasNull() ? "�" + trgr_name + "�" : "";
							}
							doctypXml.append(trgr_name);
							triggers.append(trgr_name);					
							doctypXml.append("</Attribute>\n");
						}                       
                        exp++;
						lastExcIndex = rs.getInt(1);
                    }
                    if(flag)
                    {
					doctypXml.append("</Attributes>\n");
                    doctypXml.append("</ExceptionDef>\n");
                    }
                    doctypXml.append("</ExceptionDefs>\n");
                    doctypXml.append("</Definition>");
                    if(exp != 0){
                        String srcXML = doctypXml.toString();
                        java.util.StringTokenizer st = new java.util.StringTokenizer(triggers.toString(), "�");
                        while(st.hasMoreTokens()){
                            trgr_name = st.nextToken();
                            //changed by Ashish Mangla on 18/05/2005 for Automatic Cache updation
                            String trgr_def = (String) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_Trigger, trgr_name).getData();
                            srcXML = WFSUtil.replace(srcXML, "�" + trgr_name + "�", trgr_def);
                        }
                        doctypXml = new StringBuffer(srcXML);
                       // doctypXml.append("</ExceptionHistories>\n");
                       // doctypXml.append("</Exception>\n");
                    }
                }
                doctypXml.append("<Status>");
                //----------------------------------------------------------------------------
                // Changed By				: Prashant
                // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.1_026
                // Change Description			: ActionID constants changed for Oracle.
                //---------------------------------------------------------------------------
                //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
                //SrNo-1
				pstmt = con.prepareStatement(""
                                             + " SELECT   ExceptionId,excpseqid, ActionId, ActivityName,"
                                             + " UserName, ActionDateTime,ExceptionName,ExceptionComments"
                                             + " FROM exceptionView exceptiontable" //+ " FROM exceptiontable, activitytable"	//WFS_6.1.2_070
                                             + " WHERE processdefid = ?"
                                             + " AND processinstanceid = ?"
                                             + " ORDER BY processinstanceid, processdefid, ActivityId, exceptionid, excpseqid DESC, ActionId DESC " + WFSUtil.getQueryLockHintStr(dbType));
                pstmt.setInt(1, processDefId);
                WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
                pstmt.execute();
                rs = pstmt.getResultSet();
                exp = 0;
                doctypXml.append("<ExceptionStats>\n");
                while(rs.next()){
                    // for first time its the assignment,
                    // next time if true then change to next exceptionid
                    if(exp != rs.getInt(1)){
                        if(exp == 0){
                            // first occurence of exception
                            doctypXml.append("<ExceptionStat>\n");
                        } else{
                            //finish of older exception
                            doctypXml.append("</ExceptionHistories>\n");
                            doctypXml.append("</ExceptionStat>\n");
                            doctypXml.append("<ExceptionStat>\n");
                        }
                        exp = rs.getInt(1);
                        doctypXml.append(gen.writeValueOf("ExceptionDefIndex", String.valueOf(rs.getInt(1))));
                        doctypXml.append("<ExceptionHistories>\n");
                    }
                    doctypXml.append("<ExceptionHistory>\n");
					doctypXml.append(gen.writeValueOf("ExcpSeqId", rs.getString(2)));
                    doctypXml.append(gen.writeValueOf("ActionIndex", rs.getString(3)));
					doctypXml.append(gen.writeValueOf("ActivityName", rs.getString(4)));
                    doctypXml.append(gen.writeValueOf("UserName", rs.getString(5)));
                    doctypXml.append(gen.writeValueOf("ActionDateTime", rs.getString(6)));
                    doctypXml.append(gen.writeValueOf("ExceptionName", rs.getString(7)));
                    doctypXml.append(gen.writeValueOf("ExceptionComments", rs.getString(8)));
                    doctypXml.append("</ExceptionHistory>\n");
                }
                if(exp != 0){
                    //finish up the tags of last exceptionid
                    doctypXml.append("</ExceptionHistories>\n");
                    doctypXml.append("</ExceptionStat>\n");
                }
                doctypXml.append("</ExceptionStats>\n");
                doctypXml.append("</Status>");
                doctypXml.append("</ExceptionInterface>");
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01"))
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
            } else
                descr = e.getMessage();
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
        	try {
    			  if (rs != null){
    				  rs.close();
    				  rs = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
    		  
    		  try {
      			  if (pstmt != null){
      				  pstmt.close();
      				  pstmt = null;
      			  }
      		  }
      		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
      		  
            if(mainCode != 0)
                WFSUtil.printOut(engine,gen.writeError("WMGetException", mainCode, subCode, errType,
                                                  WFSErrorMsg.getMessage(mainCode), descr));
        }
        return doctypXml.toString();
    }
	
	//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalData
//	Date Written (DD/MM/YYYY)			:	24/12/2013
//	Author								:	Kahkeshan
//	Input Parameters					:	Connection , XMLParser , XMLGenerator 
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
	public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
			return setExternalData(con,parser,gen,false);
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalData
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator ,printqueryFlag
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen,boolean printqueryFlag) throws JTSException{
        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItemId = parser.getIntOf("WorkItemID", 0, true);
        String username = parser.getValueOf("Username", "System", true);
        int userid = parser.getIntOf("Userindex", 0, true);
		int sessionID = parser.getIntOf("SessionId", 0, true);
        StringBuffer setXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        Statement stmt = null;
		int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		Boolean printQueryFlag = true;
		String queryString;
		ArrayList parameters = new ArrayList();
		try{
            int dbType = ServerProperty.getReference().getDBType(engine);
            int nooffields = parser.getNoOfFields("Exception");
            if(nooffields > 0){
                if(processDefId != 0 && activityId != 0){

                    pstmt = con.prepareStatement(" Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ? ");
                    pstmt.setInt(1, processDefId);
                    pstmt.setInt(2, activityId);
                    pstmt.execute();
                    ResultSet rs = pstmt.getResultSet();
                    String actName = "";

                    if(rs.next()){
                        actName = rs.getString(1);
						rs.close();
					}
					if(actName != null && !actName.trim().equals("")) {						
                        int start = 0;
                        int end = 0;
                        for(int i = 0; i < nooffields; i++){
                            start = parser.getStartIndex("Exception", end, 0);
                            end = parser.getEndIndex("Exception", start, 0);

                            int excpDefId = Integer.parseInt(parser.getValueOf("ExceptionDefIndex", start, end));
                            String excpDefName = parser.getValueOf("ExceptionDefName", start, end);
                            char opType = parser.getValueOf("Status", start, end).charAt(0);
                            String commnt = parser.getValueOf("ExceptionComments", start, end);
                            int res = 0;
                            int actionId = 0;
                            int excpSeqId = 0; /*excpSeqId starts with 1*/
							//SrNo-1
							if(opType != 'R'){
								if(opType == 'C' || opType == 'A' || opType == 'D'){
									try{
										excpSeqId = Integer.parseInt(parser.getValueOf("ExcpSeqId", start, end));
									}catch(Exception exp){
										/*ignore*/
									}
								}else{
									excpSeqId = Integer.parseInt(parser.getValueOf("ExcpSeqId", start, end));
								}
							}
//----------------------------------------------------------------------------
// Changed By							: Prashant
// Reason / Cause (Bug No if Any)	: Set Exception even if its not associated
// Change Description			: Set Exception even if its not associated
//----------------------------------------------------------------------------
                            switch(opType){

                                case 'R':{
                                    actionId = WFSConstant.WFL_Exception_Raised;
                                    //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
                                    //SrNo-1
									pstmt = con.prepareStatement(" Select max(excpseqid)  from Exceptionview where ExceptionId = ?  and ProcessInstanceId = ? " + " and ProcessDefId  = ? " + WFSUtil.getQueryLockHintStr(dbType));
                                    pstmt.setInt(1, excpDefId);
                                    WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
                                    pstmt.setInt(3, processDefId);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();

                                    if(rs.next()){
                                        excpSeqId = rs.getInt(1);
 										rs.close();
										pstmt.close();
										excpSeqId++;
//                    ExcpSeqId goes as, first exception will be raised, then cleared,
//                    so the seq id will be like 1for Raise operation 2for Clear operation
//                    so every odd id will be raise and every even will be clear
										try {
											if(con.getAutoCommit())
												con.setAutoCommit(false);
											pstmt = con.prepareStatement("Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID," + "USERID,USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME," + "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( ?, ? , ?, ? , ? , " + "?, ?, ?," + WFSUtil.getDate(dbType) + " , ?, ? , ? ,?) ");

											pstmt.setInt(1, excpSeqId);
											pstmt.setInt(2, processDefId);
											pstmt.setInt(3, workItemId);
											pstmt.setInt(4, activityId);
											WFSUtil.DB_SetString(5, processInst, pstmt, dbType);
											pstmt.setInt(6, userid);
											WFSUtil.DB_SetString(7, username, pstmt, dbType);
											pstmt.setInt(8, actionId);
											pstmt.setInt(9, excpDefId);
											WFSUtil.DB_SetString(10, excpDefName, pstmt, dbType);
											WFSUtil.DB_SetString(11, commnt, pstmt, dbType);
											WFSUtil.DB_SetString(12, actName, pstmt, dbType);
											res = pstmt.executeUpdate();
											pstmt.close();
                                        
                                       
                                                if(res != 0){
                                                    //There is one exception on this ProcessInstanceId
                                                    //The instrumentstatus has to be updated with E
                                                    //i.e. This instrument is in Exception
                                                /*pstmt = con.prepareStatement("Update QueueDataTable Set InstrumentStatus= ? where ProcessInstanceID= ? "+" and InstrumentStatus!= ?");*/
												queryString = "Update WFInstrumentTable Set InstrumentStatus= ? where ProcessInstanceID= ? "+" and InstrumentStatus!= ?";
												pstmt = con.prepareStatement(queryString);
												WFSUtil.DB_SetString(1, "E", pstmt, dbType);
												WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
												WFSUtil.DB_SetString(3, "E", pstmt, dbType);
                                                //    pstmt.execute();
												parameters.addAll(Arrays.asList("E",processInst,"E"));
												WFSUtil.jdbcExecute(processInst,sessionID,userid,queryString,pstmt,parameters,printQueryFlag,engine);
												pstmt.close();
												//con.commit();	
												if(!con.getAutoCommit()) {
													con.commit();
													con.setAutoCommit(true);
												}												
                                                }
                                            } catch(Exception e){
                                                WFSUtil.printErr(engine,"", e);
											if(!con.getAutoCommit()) {
												con.rollback();
												con.setAutoCommit(true);
											}
											throw e;												
                                            }

                                    }
                                    break;
                                }

								//Changed by Saurabh Kamal for Bugzilla Id 10394
                                case 'C':{
                                    actionId = WFSConstant.WFL_Exception_Cleared;
									try {
										if(con.getAutoCommit())
											con.setAutoCommit(false);
										if (excpSeqId > 0) { /*ExcpetionSequenceId has come in input*/
											pstmt = con.prepareStatement(" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID,USERID,USERNAME"
													+ ",ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME,EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( ?, ? , ?, ? , ? ,?, ?, ?, "
													+ WFSUtil.getDate(dbType) + " , ?, ? , ? ,?) ");

										pstmt.setInt(1, excpSeqId);
										pstmt.setInt(2, processDefId);
										// WSE_5.0.1_002 - Begin
										pstmt.setInt(3, workItemId);
										pstmt.setInt(4, activityId);
										WFSUtil.DB_SetString(5, processInst, pstmt, dbType);
										pstmt.setInt(6, userid);
										WFSUtil.DB_SetString(7, username, pstmt, dbType);
										pstmt.setInt(8, actionId);
										pstmt.setInt(9, excpDefId);
										WFSUtil.DB_SetString(10, excpDefName, pstmt, dbType);
										WFSUtil.DB_SetString(11, commnt, pstmt, dbType);
										WFSUtil.DB_SetString(12, actName, pstmt, dbType);
										res = pstmt.executeUpdate();
                                        pstmt.close();
                                    } else { /*Exception Sequence Id has not come in input , clear all non cleared excpetions for this exceptionid*/
                                    	//Bug Merging 64449- Query is improper and returns no record in case of Exception Trigger
                                    	pstmt = con.prepareStatement(
                                                " select  distinct(ExcpSeqId) from EXCEPTIONTABLE where processinstanceid = ? "
                                               + " and  exceptionid = ? ");
                                    		
											WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
											pstmt.setInt(2, excpDefId);
											pstmt.execute();
											rs = pstmt.getResultSet();
											stmt = con.createStatement();
											while (rs.next()) {
												int seqId = rs.getInt(1);
												pstmt = con.prepareStatement("select 1 from EXCEPTIONTABLE where ProcessInstanceId = ? and  "
	                                                    + "exceptionid = ? and ExcpSeqId = ? and ActionId = 10");
	                                            WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
	                                            pstmt.setInt(2, excpDefId);
	                                            pstmt.setInt(3, seqId);
	                                            pstmt.execute();
	                                            ResultSet rs1 = pstmt.getResultSet();
	                                            if (rs1.next()) {
	                                                continue;
	                                            }
												stmt.addBatch(" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID," + "USERID,USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME," + "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( " + seqId + " , " + processDefId + " , " + workItemId + " , " + activityId + " , " + TO_STRING(processInst, true, dbType) + " , " + userid + " , " + TO_STRING(username, true, dbType) + " , " + actionId + " , " + WFSUtil.getDate(dbType) + " , " + excpDefId + " , " + TO_STRING(excpDefName, true, dbType) + " , " + TO_STRING(commnt, true, dbType) + " , " + TO_STRING(actName, true, dbType) + " ) ");
											res++;
											}
											pstmt.close();
											stmt.executeBatch();
											stmt.close();
										}
                                        if (res > 0) {
                                            //There is one exception cleared on this ProcessInstanceId
                                            //Does the instrumentstatus has to be updated with N
                                            //depends that whether all the Exceptions are cleared
                                            //means to check existense of any cleared exceptoin
                                            //opetation with status as Live or Temporary

                                            //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
													/* Changed By : Saurabh Kamal
                                             * Changed On : 19/08/2009
                                             * Change Description : Update instrument status as N in case of
                                             * number of Raise operation is same as number Clear operation for every exception
                                             * associated with a workitem
                                             */
                                            //WFS_8.0_110
                                            /*pstmt = con.prepareStatement(" UPDATE queuedatatable SET instrumentstatus = 'N' WHERE 1 IN ( SELECT DISTINCT 1 from EXCEPTIONTABLE  where ( (SELECT  count(*) FROM EXCEPTIONTABLE WHERE ActionId = " + WFSConstant.WFL_Exception_Cleared + " and processinstanceid = ? AND processdefid = ?) >= (SELECT  count(*) FROM EXCEPTIONTABLE where ActionId = " + WFSConstant.WFL_Exception_Raised + " and processinstanceid = ? AND processdefid = ?)) ) and processinstanceid = ? ");*/ /* Bug # 5817*/
                                            //					+ " AND workitemid = ? ");		//Ashish commented WFS_6.1_045
											queryString = " UPDATE WFInstrumentTable SET instrumentstatus = 'N' WHERE 1 IN ( SELECT DISTINCT 1 from EXCEPTIONTABLE  where ( (SELECT  count(*) FROM EXCEPTIONTABLE WHERE ActionId = " + WFSConstant.WFL_Exception_Cleared + " and processinstanceid = ? AND processdefid = ?) >= (SELECT  count(*) FROM EXCEPTIONTABLE where ActionId = " + WFSConstant.WFL_Exception_Raised + " and processinstanceid = ? AND processdefid = ?)) ) and processinstanceid = ? ";
											pstmt = con.prepareStatement(queryString);
											parameters = new ArrayList();
													WFSUtil.DB_SetString(1, processInst,pstmt,dbType);
													pstmt.setInt(2, processDefId);
													WFSUtil.DB_SetString(3, processInst,pstmt,dbType);
													pstmt.setInt(4, processDefId);
													// WSE_5.0.1_002 - End
													WFSUtil.DB_SetString(5, processInst,pstmt,dbType);
									//				pstmt.setInt(4, workItemId);	//Ashish commented WFS_6.1_045
													parameters.addAll(Arrays.asList(processInst,processDefId,processInst,processDefId,processInst));
                                                    //pstmt.executeUpdate();
													WFSUtil.jdbcExecuteUpdate(processInst,sessionID,userid,queryString,pstmt,parameters,printQueryFlag,engine);;
											pstmt.close();
											//con.commit();	
											if(!con.getAutoCommit()) {
													con.commit();
													con.setAutoCommit(true);
											}									
											
                                                }
                                            } catch(Exception e){
                                                WFSUtil.printErr(engine,"", e);
										if(!con.getAutoCommit()) {
											con.rollback();
											con.setAutoCommit(true);
										}
										throw e;												
                                            }
                                    break;
                                }

                                case 'M':{

                                    actionId = WFSConstant.WFL_Exception_Modify;
                                    String queryStatement = "";
									//Bug#1773
									try {										
										queryStatement = "Select * from ( Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " actionid,ActionDateTime  from  ( Select  actionid,ActionDateTime from ExceptionTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and ProcessInstanceId = ? and ActivityId = ?  and ExceptionId = ? and Userid = ? and ExcpSeqId = ? ) A order by ActionDateTime Desc ) B " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE);
										pstmt = con.prepareStatement(queryStatement);
										pstmt.setInt(1, processDefId);
										WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
										pstmt.setInt(3, activityId);
										pstmt.setInt(4, excpDefId);
										pstmt.setInt(5, userid);
										pstmt.setInt(6, excpSeqId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										if (rs.next()) {
											int prevActionId = rs.getInt(1);
											pstmt = con.prepareStatement(" Update ExceptionTable Set ExceptionComments = ? where ProcessDefId = ? and ProcessInstanceId = ? and ActivityId = ? and ExceptionId = ? and Userid = ? and excpSeqId = ? and actionid = ? ");
											WFSUtil.DB_SetString(1, commnt, pstmt, dbType);
											pstmt.setInt(2, processDefId);
											WFSUtil.DB_SetString(3, processInst, pstmt, dbType);
											pstmt.setInt(4, activityId);
											pstmt.setInt(5, excpDefId);
											pstmt.setInt(6, userid);
											pstmt.setInt(7, excpSeqId);
											pstmt.setInt(8, prevActionId);
											res = pstmt.executeUpdate();

											if (res > 0) {
												//sucessfully modified
											} else {
												//Nothing to modify
											}
										} else {
											//No Records found to modify
										}
									}
									catch (Exception e) {
                                        WFSUtil.printErr(engine,"", e);										
										throw e;
                                    }									
                                    break;
                                }

                                case 'U':{
									actionId = WFSConstant.WFL_Exception_Undo;
                                    String queryStatement = "";
									int prevActionId = 0;
										//Bug#1773
									queryStatement = " Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " actionid from ( Select actionid from ExceptionTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ProcessDefId = ? and ProcessInstanceId = ? and ActivityId = ? and ExceptionId = ? and Userid = ?" + " and ExcpSeqId = ? order by ActionDateTime Desc ) " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE);
									pstmt = con.prepareStatement(queryStatement);
									pstmt.setInt(1, processDefId);
									WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
									pstmt.setInt(3, activityId);
									pstmt.setInt(4, excpDefId);
									pstmt.setInt(5, userid);
									pstmt.setInt(6, excpSeqId);
									pstmt.execute();
									rs = pstmt.getResultSet();
									if (rs.next()) {
										prevActionId = rs.getInt(1);
										rs.close();
									}
									try {
										if(prevActionId > 0) {
											if(con.getAutoCommit())
												con.setAutoCommit(false);
											pstmt = con.prepareStatement("Delete from ExceptionTable where ProcessDefId = ? and ProcessInstanceId = ? " + " and ActivityId = ? and ExceptionId = ? and Userid = ? and excpSeqId = ? AND actionid = ? ");
											pstmt.setInt(1, processDefId);
											WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
											pstmt.setInt(3, activityId);
											pstmt.setInt(4, excpDefId);
											pstmt.setInt(5, userid);
											pstmt.setInt(6, excpSeqId);
											pstmt.setInt(7, prevActionId);
											res = pstmt.executeUpdate();

											if (prevActionId == WFSConstant.WFL_Exception_Raised) {
													//Clear Exception
												//check whether to clear the exception or not
												try {
													//There is one exception cleared on this ProcessInstanceId
													//Does the instrumentstatus has to be updated with N
													//depends that whether all the Exceptions are cleared
													//means to check existense of any cleared exceptoin
													//opetation with status as Live or Temporary
													/*pstmt = con.prepareStatement(" UPDATE queuedatatable SET instrumentstatus = 'N' WHERE 1 NOT IN (" + " SELECT count(*) FROM exceptionview WHERE processinstanceid = ? AND processdefid = ? GROUP BY ExceptionId, ExcpSeqId ) and processinstanceid = ? ");*/ /*Bug # 5817*/
													//					+ " AND workitemid = ? ");		//Ashish commented WFS_6.1_045
													queryString = " UPDATE WFInstrumentTable SET instrumentstatus = 'N' WHERE 1 NOT IN (" + " SELECT count(*) FROM exceptionview WHERE processinstanceid = ? AND processdefid = ? GROUP BY ExceptionId, ExcpSeqId ) and processinstanceid = ? " ;
													pstmt = con.prepareStatement(queryString);
													WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
													pstmt.setInt(2, processDefId);
													WFSUtil.DB_SetString(3, processInst, pstmt, dbType);
													parameters = new ArrayList();
													parameters.addAll(Arrays.asList(processInst,processDefId,processInst));
													//pstmt.execute();
													WFSUtil.jdbcExecute(processInst,sessionID,userid,queryString,pstmt,parameters,printQueryFlag,engine);
												} catch (Exception e) {
													WFSUtil.printErr(engine,"", e);
													throw e;
												}
											} else {
												//Raise Exception
												try {
													//There is one exception on this ProcessInstanceId
													//The instrumentstatus has to be updated with E
													//i.e. This instrument is in Exception
													/*pstmt = con.prepareStatement("Update QueueDataTable Set InstrumentStatus=? where ProcessInstanceID=? and InstrumentStatus != ? ");*/
													queryString = "Update WFInstrumentTable Set InstrumentStatus=? where ProcessInstanceID=? and InstrumentStatus != ? ";
													pstmt = con.prepareStatement(queryString);
													WFSUtil.DB_SetString(1, "E", pstmt, dbType);
													WFSUtil.DB_SetString(2, processInst, pstmt, dbType);
													WFSUtil.DB_SetString(3, "E", pstmt, dbType);
													parameters.addAll(Arrays.asList("E",processInst,"E"));
													//pstmt.execute();
													WFSUtil.jdbcExecute(processInst,sessionID,userid,queryString,pstmt,parameters,printQueryFlag,engine);
												} catch (Exception e) {
													WFSUtil.printErr(engine,"", e);
													throw e;
												}
											}
										} else {
										//error no row deleted
										}
									}
									catch (Exception e) {
										WFSUtil.printErr(engine,"", e);
										if(!con.getAutoCommit()) {
											con.rollback();
											con.setAutoCommit(true);
										}
										throw e;
											}
									break;
                                } // End - Case 'U'
								/*
								 * Changed On : 13/08/2009
								 * Changed By : Saurabh Kamal
								 * Change Description : Exception havin Response and Reject operation 
								 */
								case 'A':{
									actionId = WFSConstant.WFL_Exception_Responded;
									if(excpSeqId > 0){
                                        pstmt = con.prepareStatement(" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID,USERID," + "USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME," + "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( ?, ? , ?, ? , ? , " + "?, ?, ?," + WFSUtil.getDate(dbType) + " , ?, ? , ? ,?) ");
										pstmt.setInt(1, excpSeqId);
										pstmt.setInt(2, processDefId);										
										pstmt.setInt(3, workItemId);
										pstmt.setInt(4, activityId);
										WFSUtil.DB_SetString(5, processInst, pstmt, dbType);
										pstmt.setInt(6, userid);
										WFSUtil.DB_SetString(7, username, pstmt, dbType);
										pstmt.setInt(8, actionId);
										pstmt.setInt(9, excpDefId);
										WFSUtil.DB_SetString(10, excpDefName, pstmt, dbType);
										WFSUtil.DB_SetString(11, commnt, pstmt, dbType);
										WFSUtil.DB_SetString(12, actName, pstmt, dbType);
										res = pstmt.executeUpdate();
										pstmt.close();
									}else{
										//if excpSeqId not provided in input xml then all Raised exception 
										//should be responsed for given ExceptionIndex
                                       //Bug Merging 64449- Query is improper and returns no record in case of Exception Trigger
										pstmt = con.prepareStatement(
                                                " Select ExcpSeqId from ( Select ExcpSeqId, count(*) as cnt from ExceptionView where processinstanceid = ? " +
                                                " and  exceptionid = ? group by excpseqid  ) b  where cnt = 1 " );
	
                                            
										WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
										pstmt.setInt(2, excpDefId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										stmt = con.createStatement();
										while(rs.next()){
										 	int seqId = rs.getInt(1);
                                            stmt.addBatch(" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID," + "USERID,USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME," + "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( " + seqId + " , " + processDefId + " , " + workItemId + " , " + activityId + " , " + TO_STRING(processInst, true, dbType) + " , " + userid + " , " + TO_STRING(username, true, dbType) + " , " + actionId + " , " + WFSUtil.getDate(dbType) + " , " + excpDefId + " , " + TO_STRING(excpDefName, true, dbType) + " , " + TO_STRING(commnt, true, dbType) + " , " + TO_STRING(actName, true, dbType) + " ) ");
										}
										pstmt.close();
										stmt.executeBatch();
										stmt.close();
									}
									break;
								}
								case 'D':{
									actionId = WFSConstant.WFL_Exception_Rejected;
									if(excpSeqId > 0){
                                        pstmt = con.prepareStatement(" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID,USERID," + "USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME," + "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( ?, ? , ?, ? , ? , " + "?, ?, ?," + WFSUtil.getDate(dbType) + " , ?, ? , ? ,?) ");
										pstmt.setInt(1, excpSeqId);
										pstmt.setInt(2, processDefId);										
										pstmt.setInt(3, workItemId);
										pstmt.setInt(4, activityId);
										WFSUtil.DB_SetString(5, processInst, pstmt, dbType);
										pstmt.setInt(6, userid);
										WFSUtil.DB_SetString(7, username, pstmt, dbType);
										pstmt.setInt(8, actionId);
										pstmt.setInt(9, excpDefId);
										WFSUtil.DB_SetString(10, excpDefName, pstmt, dbType);
										WFSUtil.DB_SetString(11, commnt, pstmt, dbType);
										WFSUtil.DB_SetString(12, actName, pstmt, dbType);
										res = pstmt.executeUpdate();
										pstmt.close();
									}else{
										//If excpSeqId not provided in input then all Raised and Responded 
										//Exception should be rejected for given ExceptionIndex.
										//Bug Merging 64449- Query is improper and returns no record in case of Exception Trigger
										
										pstmt = con.prepareStatement(" Select ExcpSeqId from ( Select ExcpSeqId, count(*) as cnt from ExceptionView where " +
                                        "  processinstanceid = ? and exceptionid = ? group by excpseqid  ) b  where cnt = 1");
								
										WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
										pstmt.setInt(2, excpDefId);
										pstmt.execute();
										rs = pstmt.getResultSet();
										stmt = con.createStatement();
										while(rs.next()){
										 	int seqId = rs.getInt(1);
											stmt.addBatch(
													" Insert into ExceptionTable (EXCPSEQID,PROCESSDEFID,WORKITEMID,ACTIVITYID,PROCESSINSTANCEID,"
													+ "USERID,USERNAME,ACTIONID,ACTIONDATETIME,EXCEPTIONID,EXCEPTIONNAME,"
													+ "EXCEPTIONCOMMENTS,ACTIVITYNAME) Values ( " + seqId + " , "  + processDefId + " , " + workItemId + " , " + activityId + " , " + TO_STRING(processInst , true, dbType )  +  " , "
													+ userid + " , " + TO_STRING(username , true, dbType )  + " , " + actionId + " , " + WFSUtil.getDate(dbType) + " , " + excpDefId + " , " + TO_STRING(excpDefName , true, dbType )  + " , " + TO_STRING(commnt , true, dbType )  +  " , " + TO_STRING(actName , true, dbType ) + " ) " );
										}
										pstmt.close();
										stmt.executeBatch();
										stmt.close();
									}
									break;
								}

                            } //End - Switch

                            WFSUtil.generateLog(engine, con, actionId, processInst, workItemId, processDefId, activityId, actName, 0,userid, username, excpDefId,
                                           "<ExceptionName>" + excpDefName + "</ExceptionName><ExceptionComments>" + commnt
                                           + "</ExceptionComments>", null, null, null, null);	

                        }
                    }
                    rs.close();
                    pstmt.close();
                    setXml = new StringBuffer(100);
                    setXml.append("<WFSetException_Output>\n");
                    setXml.append("<Exception>\n<SubCode>0</SubCode>\n</Exception>\n");
                    setXml.append("</WFSetException_Output>");
                }
            }
        } catch(SQLException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if(e.getErrorCode() == 0){
                if(e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                        + ")";
                }
            } else{
                descr = e.getMessage();
            }
        } catch(NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch(Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally{
            try{
                if(pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
				if(stmt != null){
                    stmt.close();
                    stmt = null;
                }

            } catch(Exception e){}
            // if (mainCode != 0) {
				// WFSUtil.printOut("in WFExceptionClass "+mainCode);
                // setXml = new StringBuffer(100);
                // setXml.append("<WFSetException_Output>\n");
                // setXml.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>"+"\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr + "</Description>\n</Exception>\n");
                // setXml.append("</WFSetException_Output>\n");
            // }
			
        }
			if(mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
        return setXml.toString();
    }

    public String getList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String inputXml = parser.getValueOf("ProcessName", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);
		Statement stmt = null;
		ResultSet rs = null;
        try{
            stmt = con.createStatement();
            String activitystr = "";
            if(activityId != 0){
                activitystr = " and ActivityInterfaceAssocTable.activityid=" + activityId;

            }
            String processDefStr = "";
            if(processDefId == 0){
                processDefStr =
                    " in ( Select Processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + TO_STRING("ProcessName", false, dbType) + " = " + TO_STRING(TO_STRING(inputXml, true, dbType), false, dbType) + ")";
            } else{
                processDefStr = " = " + processDefId;

            }
             rs = stmt.executeQuery(
                "select distinct exceptiondeftable.Exceptionid,exceptiondeftable.exceptionname "
                + " from exceptiondeftable " + WFSUtil.getTableLockHintStr(dbType) + " ,ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) 
                + " where InterfaceElementId =Exceptionid and "
                + " exceptiondeftable.processdefid=ActivityInterfaceAssocTable.processdefid "
                + " and ActivityInterfaceAssocTable.interfacetype='E' "
                + " and exceptiondeftable.processdefid " + processDefStr + activitystr);

            StringBuffer tempXml = new StringBuffer(100);

            tempXml.append("<InterfaceElementList>\n");
            while(rs.next()){
                tempXml.append("<Element>\n");
                tempXml.append("<Id>" + rs.getInt(1) + "</Id>");
                tempXml.append("<Name>" + rs.getString(2) + "</Name>");
                tempXml.append("</Element>\n");
            }
            tempXml.append("</InterfaceElementList>\n");
            return tempXml.toString();
        } catch(SQLException e){
            return "";
        } finally{
        	try {
  			  if (rs != null){
  				  rs.close();
  				  rs = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
  		  
  		  try {
    			  if (stmt != null){
    				  stmt.close();
    				  stmt = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
        }
    }

    public String searchExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

        String engine = parser.getValueOf("EngineName", "", false);
        //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
        int dbType = ServerProperty.getReference().getDBType(engine);
        int id = 0;
        if(parser.getValueOf("ID").equals("*")){
            id = -1;
        } else if(!parser.getValueOf("ID").equals("")){
            id = Integer.parseInt(parser.getValueOf("ID"));
        }
        String status = parser.getValueOf("Status");
        String inputXml = "<ProcessDefinitionID>" + parser.getIntOf("ProcessDefinitionID", 0, true) +
            "</ProcessDefinitionID><ProcessName>" + parser.getValueOf("ProcessName", "", true) + "</ProcessName>";

        Statement stmt = null;
        ResultSet rs = null;
        StringBuffer tempStr = new StringBuffer(200);
        try{

            stmt = con.createStatement();
            rs = null;
            if(id == -1){
                //Added by Varun Bhansaly on 22/01/2007 to Bugzilla Id 54
                rs = stmt.executeQuery("SELECT DISTINCT processinstanceid"
                                       + " FROM exceptionview"
                                    // + " WHERE LOWER (finalizationstatus) <> 'f' "
									    + WFSUtil.getQueryLockHintStr(dbType));
            } else{
                //Added by Varun Bhansaly on 22/01/2007 to Bugzilla Id 54
                rs = stmt.executeQuery("SELECT DISTINCT processinstanceid"
                                       + " FROM exceptionview"
                                       + " WHERE"
									  // " LOWER (finalizationstatus) <> 'f' AND"
                                       + " exceptionid = " + id + WFSUtil.getQueryLockHintStr(dbType));

            } while(rs.next()){
                tempStr.append("'").append(rs.getString(1)).append("',");

//To be removed since we will no longer return a vector
//				pInstanceList.add(rs.getString(1));

            }
            return tempStr.toString();

        } catch(SQLException e){
            return null;
        } catch(Exception ee){
            return null;
        } finally{
        	try {
  			  if (rs != null){
  				  rs.close();
  				  rs = null;
  			  }
  		  }
  		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
  		  
  		  try {
    			  if (stmt != null){
    				  stmt.close();
    				  stmt = null;
    			  }
    		  }
    		  catch(Exception ignored){WFSUtil.printErr(engine,"", ignored);}
        }
    }
    
/**********************************************************************************************************
//	Function Name 						:	setExternalInterfaceAssociation
//	Date Written (DD/MM/YYYY)			:	30/10/2009
//	Author								:	Prateek Verma
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Associates a Exception interface with a given activity, 
//                                          and changes the existing associations as well. Bug Id WFS_8.0_051.
/**********************************************************************************************************/
    @Override
    public String setExternalInterfaceAssociation(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        PreparedStatement pstmt = null;
        String strQuery = null;
        String strExceptionDef = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int iResultSetCount = 0;
        ResultSet rs = null;
		String engine = parser.getValueOf("EngineName", "", false);
		int dbType = ServerProperty.getReference().getDBType(engine);
        int iExceptionDefIndex = 0;
        String strRights = null;
        StringBuffer strXML = new StringBuffer(500);
        int processDefId = parser.getIntOf("ProcessDefId", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String strActivityName = parser.getValueOf("ActivityName", "", true);
        boolean bCreateTransaction = false;
        HashMap<String, Integer> InterfaceNameIdMap = new HashMap();        //  Map to store name Id pair for the Interface.
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            String strExceptionXML = parser.getValueOf("ExceptionInterface", "", false);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strExceptionXML);
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            String strExceptionDefinition = "";
            ArrayList distinctToDoListIds = new ArrayList();
            StringBuffer strExceptionIds = new StringBuffer();
            for(int i = 1; i <= iDefinitionCount; i++){     //  Fetching the ExceptionIDs for all the DocumentTypes.
                if(i == 1)
                    strExceptionDefinition = parser1.getFirstValueOf("Definition");
                else
                    strExceptionDefinition = parser1.getNextValueOf("Definition");
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strExceptionDefinition);
//                int iDocumentIndex = parser2.getIntOf("InterfaceElementId", 0, false);
                iExceptionDefIndex = parser2.getIntOf("InterfaceElementId", 0, true);

                //  Obtaining InterfaceId from InterfaceName if Id not provided.

                if (iExceptionDefIndex == 0) {
                    String strExceptionName = parser2.getValueOf("InterfaceName", "", false);
                    pstmt = con.prepareStatement("Select ExceptionID from ExceptionDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessdefId=? and ExceptionName =  "+TO_STRING(strExceptionName, true, dbType) + "");
                    pstmt.setInt(1, processDefId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    while (rs != null && rs.next()) {
                        iExceptionDefIndex = rs.getInt(1);  // only one item is there in the resultset
                        InterfaceNameIdMap.put(strExceptionName, iExceptionDefIndex);
                        break;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    pstmt.close();
                }
                if(i == 1){
                    strExceptionIds.append(iExceptionDefIndex);
                    distinctToDoListIds.add(iExceptionDefIndex);
                }
                else 
                    if(!distinctToDoListIds.contains(iExceptionDefIndex)){
                        distinctToDoListIds.add(iExceptionDefIndex);
                        strExceptionIds.append(", " + iExceptionDefIndex);
                    }
            }

            pstmt = con.prepareStatement("Select * from ExceptionDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessdefId=? and ExceptionId in (" + strExceptionIds + ")");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            while (rs!=null && rs.next()) {
                iResultSetCount++;
            }

            if (rs != null) {
                rs.close();
                rs = null;
            }
            pstmt.close();

            //  Changed for entry in ActivityAssociationTable Starts here.....
            //  Fetching the InterfaceId for the Form Interface from Process_InterfaceTable.
            int iExceptionDefinitionId = -1;     //  Default taken as -1.
            pstmt = con.prepareStatement("Select InterfaceId from Process_InterfaceTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + processDefId + " and InterfaceName = N'" + WFSConstant.EXT_INT_EXCEPTION_NAME + "'");
            rs = pstmt.executeQuery();

            while(rs!=null && rs.next()){
                iExceptionDefinitionId = rs.getInt("InterfaceId");
            }
            if(rs!=null){
                rs.close();
                rs = null;
            }
            pstmt.close();

            boolean bExceptionEntryExists = false;
            pstmt = con.prepareStatement("Select * from ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + processDefId + " and ActivityId = " + activityId + " and DefinitionId  = " + iExceptionDefinitionId + "and DefinitionType = N'N'");
            rs = pstmt.executeQuery();
            while(rs!=null && rs.next()){
                bExceptionEntryExists = true;
                break;
            }
            pstmt.close();

            if(!bExceptionEntryExists){
                pstmt = con.prepareStatement("Insert into ActivityAssociationTable(ProcessDefId, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjId, VariableId) " +
                            "values (" + processDefId + ", "  + activityId +", N'N', " + iExceptionDefinitionId + ", N'', N'Y,0,8235,3000,7005', N'', 0, 0)");
                pstmt.execute();
            }
            //  Changed for entry in ActivityAssociationTable Ends here.....

            if (distinctToDoListIds.size() == iResultSetCount) {
                for (int i = 1; i <= iDefinitionCount; i++) {
                    if (i == 1) {
                        strExceptionDef = parser1.getFirstValueOf("Definition");
                    } else {
                        strExceptionDef = parser1.getNextValueOf("Definition");
                    }
                    XMLParser parser2 = new XMLParser();
                    parser2.setInputXML(strExceptionDef);
                    iExceptionDefIndex = parser2.getIntOf("InterfaceElementId", 0, true);
                    if(iExceptionDefIndex == 0)
                        iExceptionDefIndex = InterfaceNameIdMap.get(parser2.getValueOf("InterfaceName", "", false));
                    strRights = parser2.getValueOf("Attribute", "", false);
                    char cOperation = parser2.getValueOf("Operation", "", false).charAt(0);
                    String strTrigger = parser2.getValueOf("TriggerName", "", true);

                    if (cOperation == 'D') {    //  Delete Query
                        pstmt.close();
                        pstmt = con.prepareStatement("Delete from ActivityInterfaceAssocTable where ProcessdefId=? and InterfaceElementId=? and ActivityId=? and InterfaceType = 'E' ");
                        pstmt.setInt(1, processDefId);
                        pstmt.setInt(2, iExceptionDefIndex);
                        pstmt.setInt(3, activityId);
                        pstmt.execute();
                    } else if (cOperation == 'A') {     //  Insert Query
                        /*System.out.println("Insert into ActivityInterfaceAssocTable(ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, Attribute, TriggerName) " +
                                "values (?, ?, ?, ?, ?, ?, ?)"); */
                        pstmt = con.prepareStatement("Insert into ActivityInterfaceAssocTable(ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, Attribute, TriggerName) " +
                                "values (?, ?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, processDefId);
                        pstmt.setInt(2, activityId);
                        pstmt.setString(3, strActivityName);
                        pstmt.setInt(4, iExceptionDefIndex);
                        pstmt.setString(5, "E");
                        pstmt.setString(6, strRights);
                        pstmt.setString(7, strTrigger);
                        pstmt.execute();
                    } else {
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WF_INVALID_OPERATION_SPECIFICATION;
                        errType = WFSError.WF_TMP;                              
                    }
                }
            } else {
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_INVALID_EXCEPTION_ID;
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                strXML.append("<WFSetExceptionAssociation_Output>");
                strXML.append("<Exception>");
                strXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strXML.append("</Exception>");
                strXML.append("</WFSetExceptionAssociation_Output>");
                if(bCreateTransaction){
                    con.setAutoCommit(true);
                    bCreateTransaction = false;
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            }

        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
           try {
               if(bCreateTransaction)
                    if(!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true); 
                }
            } catch (Exception e) {
                WFSUtil.printErr(engine,"WFEXceptionClass>> setExternalInterfaceAssociation" + e);
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                strXML.append("<WFSetExceptionAssociation_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strXML.append(objException.getMessage());
                strXML.append("</WFSetExceptionAssociation_Output>");
            }
        }
        return strXML.toString();
    }

/****************************************************************************************************
//	Function Name 						:	setExternalInterfaceMetadata
//	Date Written (DD/MM/YYYY)                               :	20/11/2009
//	Author							:	Abhishek Gupta
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:       none
//	Return Values						:	String
//	Description						:       Changes the property(name) of the Exception interface
//                                                                      for a given processDefId.
//                                                                      Bug Id WFS_8.0_051.
/****************************************************************************************************/
    @Override
    public String setExternalInterfaceMetadata(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        Statement stmt = null;
        String strQuery = null;
        String strExceptionDef = null;
        int mainCode = 0;
        int subCode = 0;
		String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int iResultSetCount = 0;
        ResultSet rs = null;
		String engine = parser.getValueOf("EngineName", "", false);
		int dbType = ServerProperty.getReference().getDBType(engine);
        int iExceptionDefIndex = 0;
        String strRights = null;
        StringBuffer strXML = new StringBuffer(500);
        int iProcessDefId = parser.getIntOf("ProcessDefId", 0, true);
//        int iActivityId = parser.getIntOf("ActivityID", 0, true);
//        String strActivityName = parser.getValueOf("ActivityName", "", true);
        boolean bCreateTransaction = false;
        try{
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            String strExceptionXML = parser.getValueOf("ExceptionInterface", "", false);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strExceptionXML);
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            stmt = con.createStatement();
			for (int i = 1; i <= iDefinitionCount; i++) {
                if (i == 1) {
                    strExceptionDef = parser1.getFirstValueOf("Definition");
                } else {
                    strExceptionDef = parser1.getNextValueOf("Definition");
                }
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strExceptionDef);
                iExceptionDefIndex = parser2.getIntOf("InterfaceElementId", 0, false);
                String strChangedExceptionName = parser2.getValueOf("ChangedExceptionName", "", true);
                if(!strChangedExceptionName.equalsIgnoreCase(""))
                    {
                    int iUpdateCount = stmt.executeUpdate("Update ExceptionDefTable set ExceptionName = "+ TO_STRING(strChangedExceptionName, true, dbType) + "where ProcessDefId = " + iProcessDefId +
                        " and ExceptionId = " + iExceptionDefIndex);
					WFSUtil.printOut(engine,"Update ExceptionDefTable set ExceptionName = "+ TO_STRING(strChangedExceptionName, true, dbType) + "where ProcessDefId = " + iProcessDefId +
                        " and ExceptionId = " + iExceptionDefIndex);
                    WFSUtil.printOut(engine,"[WFDocumentTypeClass] Update Count for ActivityInterfaceAssocTable : " + iUpdateCount);
                }
            }
            if (mainCode == 0) {
                strXML.append("<WFSetExceptionMetadata_Output>");
                strXML.append("<Exception>");
                strXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strXML.append("</Exception>");
                strXML.append("</WFSetExceptionMetadata_Output>");
                if(bCreateTransaction){
                    con.setAutoCommit(true);
                    bCreateTransaction = false;
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
           try {
               if(bCreateTransaction)
                    if(!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                }
            } catch (Exception e) {
                WFSUtil.printErr(engine,"WFEXceptionClass>> setExternalInterfaceMetadata" + e);
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                strXML.append("<WFSetExceptionMetadata_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strXML.append(objException.getMessage());
                strXML.append("</WFSetExceptionMetadata_Output>");
            }
        }
        return strXML.toString();
    }
    
    
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
                        outputXml.append(replace(in, "'", "' + char(39) + N'"));
                        outputXml.append("'");
                    } else {
                        outputXml.append(replace(in, "'", "''"));
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
                        outputXml.append(replace(in, "'", "''"));
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
                        outputXml.append("UPPER( ");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(" )");
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
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
            }
        } 
        	if(isConst)
        	{
        		return outputXml.toString();
        	}
        	else
        	{
        		return outputXml.toString().replaceAll("''", "'");
        	}
    }
	
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
    
} // class WFExceptionClasss