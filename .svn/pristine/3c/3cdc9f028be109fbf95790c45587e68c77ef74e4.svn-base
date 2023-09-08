// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFExternalInterface.java
//	Author					: Prashant
//	Date written(DD/MM/YYYY): 16/05/2002
//	Description				: Implementation of ToDoList External Interface.
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 01/10/2002			Prashant			Change for CheckListCompleteFlag
// 26/11/2002			Prashant			Bug No OF_BUG_131
// 07/06/2003			Prashant			Bug No TSR_3.0.2.0021
// 07/07/2003			Nitin Gupta			Splitting of QueueTable
// 18/05/2005           Ashish Mangla		Changes for automatic cache updation
// 22/01/2007			Varun Bhansaly      Bugzilla Bug 54 (Provide Dirty Read Support for DB2 Database)
// 09/05/2007			Varun Bhansaly      Bug WFS_5_143 (ToDoList status value allowed to be set as blank)
// 25/05/2007			Ashish Mangla		Bugzilla Bug 857 (CheckListCompleteFlag was not setting to N in case mandatory ToDo value was set to blank)
// 05/06/2007           Ruhi Hira           WFS_5_161, MultiLingual Support (Inherited from 5.0).
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 02/12/2008			Ashish Mangla		Bugzilla Bug 7101 (All Additional ToDoItems are not passed in definition)
// 09/04/2009           Saurabh Kamal       OFME(PDA) Support ,Change in getExternalData Method
// 21/04/2009           Saurabh Kamal       SrNo-2 Removal of extra <Description> tag from outputXML of this API    
// 27/04/2009           Saurabh Kamal       Bugzilla Bug 9216
// 12/06/2009			Ashish Mangla		Support of view/modify rights on TodoList (WFS_8.0_005)
// 04/11/2009           Abhishek Gupta      Bug Id WFS_8.0_051. New Functions added for setting ToDoList Interface Association with an activity and setting ToDoListMetadata(rules).(Requirement)
// 30/08/2010			Preeti Awasthi		WFS_7.1_067: TODO items are not in ascending order.
// 25/02/2011			Vikas Saraswat		Bug 1138: Todo was not displaying if we save 3 todo out of 5.
// 02/09/2011		    Shweta Singhal	    Change for SQL Injection.
// 05/07/2012  			Bhavneet Kaur   	Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
//  21/12/2013		    Kahkeshan		    Code Optimization Changes For setExternalData
// 14-03-2014			Sajid Khan			Bug 43385 [Random case: Todos not getting fetched for mobile].
// 01/05/2015			Mohnish Chopra		Changes for Case Management in getExternalData
//16/01/2018            Sajid Khan          Merging Bug 73539 - Handling for adding new ToDoItems on an old workstep.
// 05/02/2020			Shahzad Malik		Bug 90535 - Product query optimization
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.dataObject.WFFieldInfo;
import com.newgen.omni.jts.dataObject.WFVariabledef;
import com.newgen.omni.jts.excp.WFSException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class WFToDoListClass
        extends WFExternalInterface {
		

	//----------------------------------------------------------------------------------------------------
	//	Function Name 						:	setExternalData
	//	Date Written (DD/MM/YYYY)			:	16/05/2002
	//	Author								:	Prashant
	//	Input Parameters					:	Connection , XMLParser , XMLGenerator
	//	Output Parameters					:   none
	//	Return Values						:	String
	//	Description							:
	//----------------------------------------------------------------------------------------------------

		public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
			return setExternalData(con,parser,gen,false);
		}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 						:	setExternalData
	//	Date Written (DD/MM/YYYY)			:	16/05/2002
	//	Author								:	Prashant
	//	Input Parameters					:	Connection , XMLParser , XMLGenerator , printQueryFlag
	//	Output Parameters					:   none
	//	Return Values						:	String
	//	Description							:
	//----------------------------------------------------------------------------------------------------
    public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen,boolean debugFlag) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        String userName = parser.getValueOf("Username", "System", true);
        int userID = parser.getIntOf("Userindex", 0, true);
		int sessionID = parser.getIntOf("SessionId", 0, true);
        StringBuffer setXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		String queryString = null;
		ArrayList parameters = new ArrayList();
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);
            int nooffields = parser.getNoOfFields("ToDoList");
            if (nooffields > 0 && processDefId != 0 && activityId != 0) {
                pstmt = con.prepareStatement(
                        " Select ActivityName from ActivityTable  where ProcessDefId = ? and ActivityId  = ? ");
                pstmt.setInt(1, processDefId);
                pstmt.setInt(2, activityId);
                pstmt.execute();
                ResultSet rs = pstmt.getResultSet();
                String actName = "";
                boolean updateflag = false;
                char[] toDoMapArr = new char[255];
                char[] mandatoryFlag = new char[255];
														  
                String tempStr = "";
                String oldTodoString = null;
                boolean checkMandatoryCleared = false;
                if (rs.next()) {
                    actName = rs.getString(1);

                    int start = 0;
                    int end = 0;
                    rs.close();
                    pstmt.close();

//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: for Automatic Cache updation
// Change Description				: Used Singleton class CachedObjectCollection
//----------------------------------------------------------------------------
                    HashMap toDoListMap = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_TodoList, "" + 0).getData();

                    Iterator iter = toDoListMap.keySet().iterator();
                    mandatoryFlag = new char[255];
                    for (int i = 0; i < 255; i++) {
                        mandatoryFlag[i] = ' ';
                    }
													   
																			   
											 
																		  
					
                    while (iter.hasNext()) {
                        tempStr = (String) iter.next();
                        int i = Integer.parseInt(tempStr) - 1;
                        tempStr = (String) toDoListMap.get(tempStr);
                        if (tempStr.indexOf("<Mandatory>Y</Mandatory>") > -1) {
                            mandatoryFlag[i] = '1';
                        } else {
                            mandatoryFlag[i] = '0';
                        }
                    }

                    //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
                    pstmt = con.prepareStatement(
                            " Select ToDoValue from ToDoStatusView  where ProcessInstanceid = ? " + WFSUtil.getQueryLockHintStr(dbType));
                    WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs.next()) {
                        oldTodoString = rs.getString(1);
                        if (oldTodoString.indexOf("1") == -1) {
                            checkMandatoryCleared = true;
                        }
                        int toDoListMapSize = toDoListMap.size();
						if( (oldTodoString.length()) < toDoListMapSize){
							char[] tempToDoMapArr = new char[toDoListMapSize];
							for (int i = 0; i < tempToDoMapArr.length; i++) {
                            tempToDoMapArr[i] = ' ';
							}
							toDoMapArr = oldTodoString.toCharArray();
							System.arraycopy(toDoMapArr, 0, tempToDoMapArr, 0, toDoMapArr.length);
							toDoMapArr = tempToDoMapArr;
						} else{
						toDoMapArr = oldTodoString.toCharArray();
						}
																 
						updateflag = true;
                    } else {
                        tempStr = new String(mandatoryFlag);
                        toDoMapArr = tempStr.toCharArray();
																				   
						 
                    }
                    rs.close();
                    pstmt.close();

                    String toDoName = "";
                    String value = "";

                    HashMap todoVals = new HashMap();
                    for (int i = 0; i < nooffields; i++) {
                        start = parser.getStartIndex("ToDoList", end, 0);
                        end = parser.getEndIndex("ToDoList", start, 0);

                        tempStr = parser.getValueOf("ToDoIndex", start, end);
                        value = parser.getValueOf("Value", start, end);
//			Changed By Varun Bhansaly On 08/05/2007 for Bug WFS_5_143
                        if (value.equals("")) {
                            value = "0";
                        }
                        todoVals.put(tempStr, value);
                    }

                    HashMap todoarr = new HashMap();
                    iter = todoVals.keySet().iterator();
								   
																			   
											 
											 
                    char viewType = '\0';
                    int pickListCnt = 0;
													  
                    while (iter.hasNext()) {
                        tempStr = (String) iter.next();
                        parser.setInputXML((String) toDoListMap.get(tempStr));
                        value = (String) todoVals.get(tempStr);
						 
                        viewType = parser.getCharOf("ViewType", '\0', true);
											
                        todoarr.put(tempStr,"<Name>" + parser.getValueOf("Name") + "</Name><Value>" + value + "</Value>");
						if (value.equalsIgnoreCase("0") && updateflag) {
                            toDoMapArr[Integer.parseInt(tempStr) - 1] = mandatoryFlag[Integer.parseInt(tempStr) - 1];
                        } else {
											  
                            switch (viewType) {
                                case 'M':
                                    if (value.equalsIgnoreCase("Yes")) {
                                        toDoMapArr[Integer.parseInt(tempStr) - 1] = '2';
                                    } else if (value.equalsIgnoreCase("No")) {
                                        toDoMapArr[Integer.parseInt(tempStr) - 1] = '3';
                                    } else {
                                        toDoMapArr[Integer.parseInt(tempStr) - 1] = '4';
                                    }
                                    break;
                                case 'T':
                                    if (value.equalsIgnoreCase("Success")) {
                                        toDoMapArr[Integer.parseInt(tempStr) - 1] = '5';
                                    } else {
                                        toDoMapArr[Integer.parseInt(tempStr) - 1] = '6';
                                    }
                                    break;
                                case 'P':
                                    pickListCnt = parser.getNoOfFields("PickListData");
                                    if (pickListCnt == 0) {
                                        break;
                                    }
                                    XMLParser xTempParser = new XMLParser();
                                    for (int i = 0; i < pickListCnt; i++) {
                                        if (i == 0) {
                                            xTempParser.setInputXML(parser.getFirstValueOf("PickListData"));
                                        } else {
                                            xTempParser.setInputXML(parser.getNextValueOf("PickListData"));
                                        }
                                        if (value.equalsIgnoreCase(xTempParser.getValueOf("PickList"))) {
                                            toDoMapArr[Integer.parseInt(tempStr) - 1] = (char) (64 + xTempParser.getIntOf("PickListId", 0, false));
                                            break;
                                        }
                                    }
                                    break;
                            }
                        }
                    }
								
					 
                    tempStr = new String(toDoMapArr);
                    if (updateflag) {
                        pstmt = con.prepareStatement(
                                " Update ToDoStatusTable Set ToDoValue = ? where ProcessDefID = ? and ProcessInstanceID = ? ");
                    } else {
                        pstmt = con.prepareStatement(
                                " Insert into ToDoStatusTable (ToDoValue,ProcessDefID,ProcessInstanceID) Values (?,?,?) ");
//----------------------------------------------------------------------------
// Changed By											: Prashant
// Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0021
// Change Description							:	Set ToDoStatus after performing LTRIM
//----------------------------------------------------------------------------
                    }
                    WFSUtil.DB_SetString(1, tempStr.substring(0,
                            tempStr.indexOf(tempStr.trim()) + tempStr.trim().length()), pstmt, dbType);
                    pstmt.setInt(2, processDefId);
                    WFSUtil.DB_SetString(3, processInst, pstmt, dbType);

                    int res = pstmt.executeUpdate();
                    pstmt.close();
                    if (res > 0 && todoarr.size() > 0) {
                        iter = todoarr.keySet().iterator();
                        while (iter.hasNext()) {
                            tempStr = (String) iter.next();
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_ToDoItemStatus_Modified, processInst, workItem, processDefId, activityId, actName, 0,
                                    userID, userName, Integer.parseInt(tempStr),
                                    (String) todoarr.get(tempStr), null, null, null, null);
                        }
                        tempStr = new String(toDoMapArr);
                        if (tempStr.indexOf("1") == -1) {
                            /*pstmt = con.prepareStatement(
                                    " Update QueueDatatable Set CheckListCompleteFlag = 'Y' where ProcessInstanceID = ? ");*/
							queryString = " Update WFInstrumentTable Set CheckListCompleteFlag = 'Y' where ProcessInstanceID = ? " ;
                            pstmt = con.prepareStatement(queryString);
                            WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
                            parameters.add(processInst);
                            //pstmt.executeUpdate();
							WFSUtil.jdbcExecuteUpdate(processInst,sessionID,userID,queryString,pstmt,parameters,debugFlag,engine);
                            pstmt.close();
                        } else if (checkMandatoryCleared) {
                            /*pstmt = con.prepareStatement(
                                    " Update QueueDatatable Set CheckListCompleteFlag = 'N' where ProcessInstanceID = ? ");*/
																				
							queryString = " Update WFInstrumentTable Set CheckListCompleteFlag = 'N' where ProcessInstanceID = ? " ;
                            pstmt = con.prepareStatement(queryString);
                            WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
                            parameters.add(processInst);
                            //pstmt.executeUpdate();
							WFSUtil.jdbcExecuteUpdate(processInst,sessionID,userID,queryString,pstmt,parameters,debugFlag,engine);
                            pstmt.close();
                        }

                    }
                } else {
                    rs.close();
                    pstmt.close();
                }
                setXml = new StringBuffer(100);
                setXml.append("<WFSetToDoList_Output>\n");
                setXml.append("<Exception><MainCode>"+WFSError.WM_SUCCESS);       
                setXml.append("</MainCode>\n<SubCode>0</SubCode>\n</Exception>\n");
                setXml.append("</WFSetToDoList_Output>");
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
            } else {
                descr = e.getMessage();
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
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                setXml = new StringBuffer(100);
                setXml.append("<WFSetToDoList_Output>\n");
																							 
                setXml.append("<Exception>\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr + "</Description>\n</Exception>\n");
                setXml.append("</WFSetToDoList_Output>\n");
            }
        }
        return setXml.toString();

    }

    public String getList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String inputXml = parser.getValueOf("ProcessName", "", true);
        int dbType = ServerProperty.getReference().getDBType(engine);

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = con.createStatement();
            String activitystr = "";
            if (activityId != 0) {
                activitystr = " and ActivityInterfaceAssocTable.activityid=" + activityId;

            }
            String processDefStr = "";
            if (processDefId == 0) {
                processDefStr =
                        " in ( Select Processdefid  from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + WFSUtil.TO_STRING("ProcessName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(inputXml, true, dbType), false, dbType) + " )";
            } else {
                processDefStr = " = " + processDefId;

            }
             rs = stmt.executeQuery(
                    "select distinct todolistdeftable.todoid,todolistdeftable.todoname " + " from todolistdeftable " + WFSUtil.getTableLockHintStr(dbType) + " ,ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) + " where InterfaceElementId =todoid and todolistdeftable.processdefid=ActivityInterfaceAssocTable.processdefid " + " and ActivityInterfaceAssocTable.interfacetype='T' " + " and todolistdeftable.processdefid " + processDefStr + activitystr);

            StringBuffer tempXml = new StringBuffer(100);

            tempXml.append("<InterfaceElementList>\n");
            while (rs.next()) {
                tempXml.append("<Element>\n");
                tempXml.append("<Id>" + rs.getInt(1) + "</Id>");
                tempXml.append("<Name>" + rs.getString(2) + "</Name>");
                tempXml.append("</Element>\n");
            }
            tempXml.append("</InterfaceElementList>\n");
            return tempXml.toString();
        } catch (SQLException e) {
            return "";
        } finally {
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

    public String searchExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        String engine = parser.getValueOf("EngineName", "", false);
        int id = 0;
        if (parser.getValueOf("ID").equals("*")) {
            id = -1;
        } else if (!parser.getValueOf("ID").equals("")) {
            id = Integer.parseInt(parser.getValueOf("ID"));
        }
        String status = parser.getValueOf("Status");
        String inputXml = "<ProcessDefinitionID>" + parser.getIntOf("ProcessDefinitionID", 0, true) +
                "</ProcessDefinitionID><ProcessName>" + parser.getValueOf("ProcessName", "", true) + "</ProcessName>";

        Statement stmt = null;
        int dbType = ServerProperty.getReference().getDBType(engine);
        String idstr = "";

        try {
            int start = inputXml.toUpperCase().indexOf("<PROCESSDEFINITIONID>");
            int end = inputXml.toUpperCase().indexOf("</PROCESSDEFINITIONID>");
            String str = "";
            if (id == -1) {
                idstr = " where todoValue is not null";
            } else {
                idstr = " where " + WFSUtil.substr("ToDoValue", id, 1, dbType) + " >= '2' ";

            }
            if (start > -1 && end > start) {
                str = inputXml.substring(start + 21, end);
                if (!str.startsWith("0")) {
                    idstr += " and ProcessDefId = " + inputXml.substring(start + 21, end);
                } else {
                    start = inputXml.toUpperCase().indexOf("<PROCESSNAME>");
                    end = inputXml.toUpperCase().indexOf("</PROCESSNAME>");
                    if (start > -1 && end > start) {
                        idstr +=
								" and ProcessDefId in ( Select ProcessDefId from ProcessDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where Processname = "
								+ WFSUtil.TO_STRING(inputXml.substring(start + 13, end), true, dbType) + ")";
                    }
                }
            }

            stmt = con.createStatement();
            String qry = "";
            if (status.equals("C")) {
                if (id == -1) {
                    qry = "select processinstanceid from todostatusView " + idstr + " and " + WFSUtil.charIndex(dbType, "ToDoValue",
                            "'0'") + " <= 0 and " + WFSUtil.charIndex(dbType, "ToDoValue", "'1'") + " <= 0";
                } else {
                    qry = "select processinstanceid from todostatusView " + WFSUtil.TO_SANITIZE_STRING(idstr,true);
                }
            } else if (status.equals("P")) {
                if (id == -1) {
                    qry = "select distinct processinstanceid " + " from ActivityInterfaceAssocTable,ProcessInstanceTable " + " where ActivityInterfaceAssocTable.processdefid=ProcessInstanceTable.processdefid " + " and ActivityInterfaceAssocTable.activityid=ProcessInstanceTable.activityid " + " and ActivityInterfaceAssocTable.interfacetype='T' " + " and InterfaceElementId is not null and processinstanceid  not in " + " ( select distinct todostatusview.processinstanceid  from todostatustable " + "	where todostatustable.processdefid=ActivityInterfaceAssocTable.processdefid " + " and ActivityInterfaceAssocTable.interfacetype='T' )";
                } else {
                    qry = "select distinct processinstanceid " + " from ActivityInterfaceAssocTable,ProcessInstanceTable " + " where ActivityInterfaceAssocTable.processdefid=ProcessInstanceTable.processdefid " + " and ActivityInterfaceAssocTable.activityid=ProcessInstanceTable.activityid " + " and ActivityInterfaceAssocTable.interfacetype='T' " + " and InterfaceElementId=" + id + " and processinstanceid  not in " + " ( select distinct todostatustable.processinstanceid  from todostatustable " + "	where todostatustable.processdefid=ActivityInterfaceAssocTable.processdefid " + " and ActivityInterfaceAssocTable.interfacetype='T' " + "	and " + WFSUtil.substr("ToDoValue", id, 1, dbType) + " >= '2' )";
                }
            } else {
                return "";
            }

//      WFSUtil.printOut(parser,"qr=" + qry);
            //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
            ResultSet rs = stmt.executeQuery(WFSUtil.TO_SANITIZE_STRING(qry,true) + WFSUtil.getQueryLockHintStr(dbType));
            StringBuffer pInstanceList = new StringBuffer();
            while (rs.next()) {
                pInstanceList.append("'" + rs.getString(1).trim() + "',");
            }
            return pInstanceList.toString();

        } catch (SQLException e) {
            return "";
        } catch (JTSException e) {
            return "";
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
        }
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WMGetToDoList
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
        /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
        String locale = parser.getValueOf("Locale");
        //Key for Todo Caching
        //String pdaFlag = parser.getValueOf("PDAFlag", "N", true);
        int procVarId = parser.getIntOf("VariantId", 0, true);
        int taskId = parser.getIntOf("TaskId",0,true);
        String pdaFlag =parser.getValueOf("PDAFlag", "N", true);
		char char21 = 21;
		String string21 = "" + char21;
		char char25 = 25;
		String string25 = "" + char25;
        String key = activityId + string21 + pdaFlag+ string25 + procVarId;

        StringBuffer doctypXml = new StringBuffer(1000);
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String srcXML = "";
//    XMLGenerator gen = new XMLGenerator();

        try {
            java.util.LinkedHashMap todoStatMap = new java.util.LinkedHashMap();
            StringBuffer todoTrgrMap = new StringBuffer(64);
            StringBuffer todoPLstMap = new StringBuffer(64);
            int dbType = ServerProperty.getReference().getDBType(engine);
            String tempStr = "";
            String attribute = "";
            if (processDefId != 0 && activityId != 0) {
                if (defnflag == 'Y' || isCacheExpired(con, parser)) {
                    //SrNo-2
                	//Changes for Case Management
                	if(taskId<=0){
                		pstmt = con.prepareStatement(
                				" Select InterfaceElementID, Attribute from ActivityInterfaceAssocTable A, todolistdeftable T "
                				+ "where A.ProcessDefID = ? and A.ActivityID  = ? and InterfaceType = 'T' and interfaceelementid = todoid order by todoid ASC");
                		pstmt.setInt(1, processDefId);
                		pstmt.setInt(2, activityId);
                	}
                	else  	{
                		pstmt = con.prepareStatement(
                				" Select InterfaceID, Attribute from WFRTTaskInterfaceAssocTable  A, todolistdeftable T "
                				+ "where A.ProcessInstanceId = ? AND A.WorkItemId=? and A.ProcessDefID = ? and A.ActivityID  = ? and A.TaskId = ? and InterfaceType = 'T' and interfaceid = todoid order by todoid ASC");
                		pstmt.setString(1, processInst);
                		pstmt.setInt(2, workItem);	
                		pstmt.setInt(3, processDefId);
                		pstmt.setInt(4, activityId);
                		pstmt.setInt(5, taskId);
                	}
					
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    while (rs.next()) {
                        tempStr = rs.getString(1);
                        attribute = rs.getString(2);	//WFS_8.0_005
                        attribute = gen.writeValueOf("Attribute", attribute);
                        attribute += "<AdditionalToDoItem>N</AdditionalToDoItem>\n";

                        todoStatMap.put(tempStr, attribute);
                    }
                    rs.close();
                    pstmt.close();
                }
                //Added by Varun Bhansaly on 22/01/2007 for Bugzilla Id 54
                pstmt = con.prepareStatement(
                        " Select ToDoValue from ToDoStatusView where ProcessInstanceid = ? " + WFSUtil.getQueryLockHintStr(dbType));
                WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
                pstmt.execute();
                tempStr = "";
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    tempStr = rs.getString(1);
                    tempStr = rs.wasNull() ? "" : tempStr.substring(0,
                            tempStr.indexOf(tempStr.trim()) + tempStr.trim().length());
                }
                rs.close();
                pstmt.close();

                doctypXml.append("<ToDoListInterface>");
                doctypXml.append("<Status>");
                doctypXml.append("<ToDoListStats>\n");

                char[] todoStatarr = tempStr.toCharArray();
                int pickListOff = 0;
                
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: for Automatic Cache updation
// Change Description				: Used Singleton class CachedObjectCollection
//----------------------------------------------------------------------------
                HashMap todoListMap = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, processDefId, WFSConstant.CACHE_CONST_TodoList, key).getData();
                
                ArrayList toDoIndex = new ArrayList();
                Collections.addAll(toDoIndex, todoListMap.keySet().toArray());
                Collections.sort(toDoIndex);
                
                for (int i = 0; i < todoStatarr.length; i++) {
                    if (todoStatarr[i] != ' ') {
                        switch (todoStatarr[i]) {
                            case '0':
                                break;
                            case '1':
                                break;
                            case '2':
                                doctypXml.append("<ToDoListStat>\n");
                                doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                doctypXml.append(gen.writeValueOf("Value", "Yes"));
                                doctypXml.append("</ToDoListStat>\n");
                                break;
                            case '3':
                                doctypXml.append("<ToDoListStat>\n");
                                doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                doctypXml.append(gen.writeValueOf("Value", "No"));
                                doctypXml.append("</ToDoListStat>\n");
                                break;
                            case '4':
                                doctypXml.append("<ToDoListStat>\n");
                                doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                doctypXml.append(gen.writeValueOf("Value", "Not Applicable"));
                                doctypXml.append("</ToDoListStat>\n");
                                break;
                            case '5':
                                doctypXml.append("<ToDoListStat>\n");
                                doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                doctypXml.append(gen.writeValueOf("Value", "Success"));
                                doctypXml.append("</ToDoListStat>\n");
                                break;
                            case '6':
                                doctypXml.append("<ToDoListStat>\n");
                                doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                doctypXml.append(gen.writeValueOf("Value", "Fail"));
                                doctypXml.append("</ToDoListStat>\n");
                                break;
                            default: {
                                pickListOff = (int) todoStatarr[i] - 64;
                                if (pickListOff > 0) {
                                	String value = "";
                                    tempStr = (String) todoListMap.get(String.valueOf(toDoIndex.get(i)));
                                    if (tempStr != null && !tempStr.trim().equals("")) {
                                        XMLParser xParser = new XMLParser(tempStr);
                                        XMLParser xTempParser = new XMLParser();
                                        int iPickListDataCount = xParser.getNoOfFields("PickListData");
                                        for (int j = 0; j < iPickListDataCount; j++) {
                                            if (j == 0) {
                                                xTempParser.setInputXML(xParser.getFirstValueOf("PickListData"));
                                            } else {
                                                xTempParser.setInputXML(xParser.getNextValueOf("PickListData"));
                                            }
                                            if (xTempParser.getIntOf("PickListId", 0, false) == pickListOff) {
                                                value = xTempParser.getValueOf("PickList");
                                                break;
                                            }
                                        }
                                    }
                                    doctypXml.append("<ToDoListStat>\n");
                                    doctypXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(toDoIndex.get(i))));
                                    doctypXml.append(gen.writeValueOf("Value", value));
                                    doctypXml.append("</ToDoListStat>\n");
                                }
                            }
                        }
                    }
                }

                doctypXml.append("</ToDoListStats>\n");
                doctypXml.append("</Status>");

                if (defnflag == 'Y' || isCacheExpired(con, parser)) {
                    Iterator additionalIterator = todoListMap.keySet().iterator();	//Bugzilla Bug 7101
                    Object additionalObjKey = null;
                    while (additionalIterator.hasNext()) {
                        additionalObjKey = additionalIterator.next();
                        if (!todoStatMap.containsKey(additionalObjKey)) {
                            todoStatMap.put(additionalObjKey, "<AdditionalToDoItem>Y</AdditionalToDoItem>\n");
                        }
                    }

                    doctypXml.append("<Definition>");
                    doctypXml.append("<ToDoListDefs>\n");
                    Iterator iter = todoStatMap.keySet().iterator();
                    Object obj = null;
                    if (todoStatMap.size() > 0) {
                        while (iter.hasNext()) {
                            obj = iter.next();
                            //Change for not appending null object *Saurabh Kamal
                            if (todoListMap.get(obj) != null) {
                                doctypXml.append("<ToDoListDef>\n");
                                doctypXml.append(todoListMap.get(obj));
                                doctypXml.append(todoStatMap.get(obj));
                                doctypXml.append("</ToDoListDef>\n");
                            }

                        }
                    }
                    doctypXml.append("</ToDoListDefs>\n");
                    doctypXml.append("</Definition>");
                }
                doctypXml.append("</ToDoListInterface>");
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
            } else {
                descr = e.getMessage();
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
            if (mainCode != 0) {
                WFSUtil.printOut(engine,gen.writeError("WMGetToDoList", mainCode, subCode, errType,
                        WFSErrorMsg.getMessage(mainCode), descr));
            }
        }
        return doctypXml.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalInterfaceAssociation
//	Date Written (DD/MM/YYYY)			:	30/10/2009
//	Author								:	Abhishek GUpta
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   Associates a ToDoList interface with a given activity, 
//                                          and changes the existing associations as well. Bug Id WFS_8.0_051.
//----------------------------------------------------------------------------------------------------    
    @Override
    public String setExternalInterfaceAssociation(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        int mainCode = 0;
        int subCode = 0;
		String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Statement stmt = null;
        StringBuffer strReturnXML = new StringBuffer(100);
        boolean bCreateTransaction = false;
        ResultSet rs = null;
		String engine = parser.getValueOf("EngineName", "", false);
		int dbType = ServerProperty.getReference().getDBType(engine);
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            String strToDoListDefinition = "";
            stmt = con.createStatement();
            int iToDoListIndex = 0;
            HashMap<String, Integer> InterfaceNameIdMap = new HashMap();        //  Map to store name Id pair for the Interface.
            int iProcessDefId = parser.getIntOf("ProcessDefID", 0, false);
            int iActivityId = parser.getIntOf("ActivityID", 0, false);
            String strActivityName = parser.getValueOf("ActivityName", "", false);
            String strToDoListXML = parser.getValueOf("ToDoListInterface", "", true);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strToDoListXML);
            int iDefinitionCount = parser1.getNoOfFields("Definition");
            StringBuffer strToDoListIds = new StringBuffer();
            ArrayList distinctToDoListIds = new ArrayList();
			for (int i = 1; i <= iDefinitionCount; i++) {     //  Fetching the DocumentTypeIDs for all the DocumentTypes.
                if (i == 1) {
                    strToDoListDefinition = parser1.getFirstValueOf("Definition");
                } else {
                    strToDoListDefinition = parser1.getNextValueOf("Definition");
                }
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strToDoListDefinition);
                iToDoListIndex = parser2.getIntOf("InterfaceElementId", 0, true);

                //  Obtaining InterfaceId from InterfaceName if Id not provided.

                if (iToDoListIndex == 0) {
                    String strToDoListName = parser2.getValueOf("InterfaceName", "", false);
                    rs = stmt.executeQuery("Select todoid from ToDoListDefTable where ProcessdefId = " + iProcessDefId + " and todoName = "+ WFSUtil.TO_STRING(strToDoListName, true, dbType) + "");
                    while (rs != null && rs.next()) {
                        iToDoListIndex = rs.getInt(1);
                        InterfaceNameIdMap.put(strToDoListName, iToDoListIndex);
                        break;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                }

                if (i == 1) {
                    strToDoListIds.append(iToDoListIndex);
                    distinctToDoListIds.add(iToDoListIndex);
                } else if (!distinctToDoListIds.contains(iToDoListIndex)) {
                    distinctToDoListIds.add(iToDoListIndex);
                    strToDoListIds.append(", " + iToDoListIndex);
                }
            }
            //	Checking whether the given ToDoList exists in the process scope or not.
            rs = stmt.executeQuery("Select * from ToDoListDefTable where ProcessDefId = " + iProcessDefId + " and ToDoId in (" + strToDoListIds + ")");
            int iResultSetCount = 0;
            while (rs != null && rs.next()) {   //  Counting the number of rows in the Resultset.
                ++iResultSetCount;
            }

            if (rs != null) {
                rs.close();
                rs = null;
            }

            //  Changed for entry in ActivityAssociationTable Starts here.....
            //  Fetching the InterfaceId for the ToDoList Interface from Process_InterfaceTable.
            int iToDoDefinitionId = -1;     //  Default taken as -1.
            stmt = con.createStatement();
            rs = stmt.executeQuery("Select InterfaceId from Process_InterfaceTable where ProcessDefId = " + iProcessDefId + " and InterfaceName = N'" + WFSConstant.EXT_INT_TODOLIST_NAME + "'");

            while(rs!=null && rs.next()){
                iToDoDefinitionId = rs.getInt("InterfaceId");
            }
            if(rs!=null){
                rs.close();
                rs = null;
            }

            boolean bToDoEntryExists = false;
            stmt = con.createStatement();
            rs = stmt.executeQuery("Select * from ActivityAssociationTable where ProcessDefId = " + iProcessDefId + " and ActivityId = " + iActivityId + " and DefinitionId  = " + iToDoDefinitionId + "and DefinitionType = N'N'");

            while(rs!=null && rs.next()){
                bToDoEntryExists = true;
                break;
            }

            if(!bToDoEntryExists){
                stmt.execute("Insert into ActivityAssociationTable(ProcessDefId, ActivityId, DefinitionType, DefinitionId, AccessFlag, FieldName, Attribute, ExtObjId, VariableId) " +
                            "values (" + iProcessDefId + ", "  + iActivityId +", N'N', " + iToDoDefinitionId + ", N'', N'Y,0,915,7305,7005', N'', 0, 0)");
            }
            //  Changed for entry in ActivityAssociationTable Ends here.....

            if (distinctToDoListIds.size() == iResultSetCount) {  //  All ToDoLists received exist in the process scope.
                for (int i = 1; i <= iDefinitionCount; i++) {
                    if (i == 1) {
                        strToDoListDefinition = parser1.getFirstValueOf("Definition");
                    } else {
                        strToDoListDefinition = parser1.getNextValueOf("Definition");
                    }
                    XMLParser parser2 = new XMLParser();
                    parser2.setInputXML(strToDoListDefinition);
                    iToDoListIndex = parser2.getIntOf("InterfaceElementId", 0, true);
                    if (iToDoListIndex == 0) {
                        iToDoListIndex = InterfaceNameIdMap.get(parser2.getValueOf("InterfaceName", "", false));
                    }
                    String strAttribute = parser2.getValueOf("Attribute", "", false);
                    char cOperation = parser2.getValueOf("Operation", "", false).charAt(0);

                    if (cOperation == 'D') {     //Delete Query
                        stmt.execute("Delete from ActivityInterfaceAssocTable where ProcessDefId = " + iProcessDefId + " and  ActivityId = " + iActivityId + " and InterfaceElementId = " + iToDoListIndex + " and InterfaceType = N'T'");
                    } else if (cOperation == 'U') {     //Update Query
                        int iUpdateCount = stmt.executeUpdate("Update ActivityInterfaceAssocTable set Attribute = "+ WFSUtil.TO_STRING(strAttribute, true, dbType) + "where ProcessDefId = " + iProcessDefId + " and  ActivityId = " + iActivityId + " and InterfaceElementId = " + iToDoListIndex + " and InterfaceType = N'T'");
                        WFSUtil.printOut(engine,"[WFDocumentTypeClass] Update Count for ActivityInterfaceAssocTable : " + iUpdateCount);
                    } else if (cOperation == 'A') {      //Insert Query
                        stmt.execute("Insert into ActivityInterfaceAssocTable(ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, Attribute) " +
                                "values (" + iProcessDefId + ", " + iActivityId + ", "+ WFSUtil.TO_STRING(strActivityName, true, dbType) + ", " + iToDoListIndex + ", N'T', "+ WFSUtil.TO_STRING(strAttribute, true, dbType) + ")");
                        WFSUtil.printOut(engine,"[WFDocumentTypeClass] Update Count for ActivityInterfaceAssocTable : ");
                    } else {    //  Throw Error
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WF_INVALID_OPERATION_SPECIFICATION;
                        errType = WFSError.WF_TMP;
                    }
                }
            } else {        //  Throw Error
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_INVALID_TODOLIST_ID;
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                strReturnXML.append("<WFSetToDoListAssociation_Output>");
                strReturnXML.append("<Exception>");
                strReturnXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strReturnXML.append("</Exception>");
                strReturnXML.append("</WFSetToDoListAssociation_Output>");
                if (bCreateTransaction) {
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
            } else {
                descr = e.getMessage();
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
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (bCreateTransaction) {
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception e) {
                WFSUtil.printErr(engine,"WFToDoListClass>> setExternalInterfaceAssociation" + e);
            }

            if (mainCode != 0) {
                strReturnXML.append("<WFSetToDoListAssociation_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strReturnXML.append(objException.getMessage());
                strReturnXML.append("</WFSetToDoListAssociation_Output>");
            }
        }
        return strReturnXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalInterfaceRules
//	Date Written (DD/MM/YYYY)                               :	23/11/2009
//	Author							:	Abhishek Gupta
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:       none
//	Return Values						:	String
//	Description						:       Set the rules for ToDoList Interface.
//----------------------------------------------------------------------------------------------------
    @Override
    public String setExternalInterfaceRules(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {
        int mainCode = 0;
        int subCode = 0;
		String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Statement stmt = null;
        StringBuffer strReturnXML = new StringBuffer(100);
        boolean bCreateTransaction = false;
        ResultSet rs = null;
		String engine = parser.getValueOf("EngineName", "", false);
		int dbType = ServerProperty.getReference().getDBType(engine);
		char char21 = 21;
		String string21 = "" + char21;
        try {
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCreateTransaction = true;
            }
            String str = "abc";
            stmt = con.createStatement();
            String strToDoListDefinition = "";
            int iProcessDefId = parser.getIntOf("ProcessDefID", 0, false);
            String strEngineName = parser.getValueOf("EngineName", "", false);
            String strToDoListXML = parser.getValueOf("ToDoListInterface", "", true);
            XMLParser parser1 = new XMLParser();
            parser1.setInputXML(strToDoListXML);
			int iDefinitionCount = parser1.getNoOfFields("Definition");
            int iMaxRuleId = 0;
            if(iDefinitionCount > 0){
                rs = stmt.executeQuery("Select MAX(RuleId) as MaxRuleId from WFExtInterfaceConditionTable");
                //System.out.println("Select MAX(RuleId) as MaxRuleId from WFExtInterfaceConditionTable");
                while (rs != null && rs.next()) {   //  Fetching the Maximum Rule Id for the new condition.
                    iMaxRuleId = rs.getInt(1);
                    break;
                }
            }

            for (int i = 1; i <= iDefinitionCount; i++) {
                //System.out.println("Definition count ::::::::::::: " + iDefinitionCount);
                iMaxRuleId++;       //  Incrementing the Max rule id by 1.
                if (i == 1) {
                    strToDoListDefinition = parser1.getFirstValueOf("Definition");
                } else {
                    strToDoListDefinition = parser1.getNextValueOf("Definition");
                }
                XMLParser parser2 = new XMLParser();
                parser2.setInputXML(strToDoListDefinition);
                int iConditionOrderId = 0;
                String strRuleConditionsXML = parser2.getValueOf("RuleConditions", "", false);
                parser2.setInputXML(strRuleConditionsXML);
                int iRuleConditionCount = parser2.getNoOfFields("RuleCondition");
                String strRuleCondition = "";


                //  Operating on a Rule Condition.
                for (int i1 = 1; i1 <= iRuleConditionCount; i1++) {
                    iConditionOrderId++;    //  Incrementing the condition order id by 1.
                    if (i1 == 1) {
                        strRuleCondition = parser2.getFirstValueOf("RuleCondition");
                    } else {
                        strRuleCondition = parser2.getNextValueOf("RuleCondition");
                    }
                    XMLParser parser3 = new XMLParser();
                    parser3.setInputXML(strRuleCondition);

                    //      Operating for Param1    -------------------------------------------
                    int iVariableId1 = parser3.getIntOf("VariableId1", 0, true);      
                    int iVarFieldId1 = parser3.getIntOf("VarFieldId1", 0, true);
                    int iExtObjId1 = 0;
                    int iOperator = parser3.getIntOf("Operator", 0, false);
                    int iLogicalOperator = parser3.getIntOf("LogicalOperator", 0, false);
                    String strFetchedParameter = "";
                    String strLeafParam1 = "";
                    String strLeafParam2 = "";
                    char cType1 = '\n';
                    char cType2 = '\n';
                    //  Case when variableId and varFieldId is provided.
                    if(!(iVariableId1 == 0 && iVarFieldId1 == 0)){
                        //System.out.println("Inside If");
                        WFVariabledef attributeMap = (WFVariabledef)CachedObjectCollection.getReference().getCacheObject(con, strEngineName, iProcessDefId, WFSConstant.CACHE_CONST_Variable, "" + 0).getData();
                        //System.out.println(" AllFieldInfoMap : " + attributeMap.getAllFieldInfoMap());
                        //System.out.println(" \n\nAttribMap : " + attributeMap.getAttribMap());
//                        for(int iCounter = 1; iCounter <= attributeMap.getAllFieldInfoMap().size(); iCounter ++){
//                            System.out.println("Inside For : Counter  :" + iCounter);
                            if(attributeMap.getAllFieldInfoMap().containsKey((iVariableId1 + string21 + iVarFieldId1).toUpperCase())){
                                //System.out.println("Inside Inner If for getAllFieldInfoMap()");
                                WFFieldInfo wfFieldInfo = (WFFieldInfo)attributeMap.getAllFieldInfoMap().get((iVariableId1 + string21 + iVarFieldId1).toUpperCase());
                                strLeafParam1 = wfFieldInfo.getName();
                                cType1 = wfFieldInfo.getScope();
                                iExtObjId1 = wfFieldInfo.getExtObjId();
                            }
//                        }
                    } else {    //  Case when variableId and varFieldId are not provided.
                        //System.out.println("Inside Else");
                        String strParam1 = parser3.getValueOf("Param1", "", true);
                        strLeafParam1 = strParam1;       //  Parameter to be finally inserted into the table.
                        if (strParam1.contains(".")) {
                            strLeafParam1 = strParam1.substring(strParam1.lastIndexOf(".") + 1);
                        }
                        strFetchedParameter = strParam1;
                        cType1 = parser3.getValueOf("Type1", "", false).charAt(0);
                        if (String.valueOf(cType1).equalsIgnoreCase("V") || String.valueOf(cType1).equalsIgnoreCase("C")) {     //  Param1 can be Constant or Null.
                            iVariableId1 = 0;
                            iVarFieldId1 = 0;
                        } else {
                            if (strParam1.contains(".")) //  In case of complex types, we have variables like A.B.C. Here we fetch A
                            {
                                strFetchedParameter = strParam1.substring(0, strParam1.indexOf("."));
                            }
                            rs = stmt.executeQuery("Select ExtObjId, VariableId from VarMappingTable where ProcessDefId = " + iProcessDefId + " and UserDefinedName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + " and VariableScope = "+ WFSUtil.TO_STRING(Character.toString(cType1), true, dbType) + "");
                            /*System.out.println("Select ExtObjId, VariableId from VarMappingTable where ProcessDefId = " + iProcessDefId + " and UserDefinedName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + " and VariableScope = "+ WFSUtil.TO_STRING(Character.toString(cType1), true, dbType) + "");*/
                            while (rs != null && rs.next()) {   //  Fetching the external Object Id for the variable
                                iExtObjId1 = rs.getInt(1);
                                iVariableId1 = rs.getInt(2);
                                break;
                            }
                            if (iExtObjId1 != 0) {    //  If the variable in external table is mapped to a user defined variable(case of complex type).
                                if (strParam1.contains(".")) //  In case of complex types, we have variables like A.B.C. Here we fetch C
                                {
                                    strFetchedParameter = strParam1.substring(strParam1.lastIndexOf(".") + 1);
                                }
                                rs = stmt.executeQuery("Select VarFieldId from WFUDTVarmappingTable where ProcessDefId = " + iProcessDefId + " and ExtObjId = " + iExtObjId1 + " and VariableId = " + iVariableId1 + " and MappedObjectName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + "");
                                /*System.out.println("Select VarFieldId from WFUDTVarmappingTable where ProcessDefId = " + iProcessDefId + " and ExtObjId = " + iExtObjId1 + " and VariableId = " + iVariableId1 + " and MappedObjectName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + "");*/
                                while (rs != null && rs.next()) {   //  Fetching the external Object Id for the variable
                                    iVarFieldId1 = rs.getInt(1);
                                    break;
                                }
                            } else {
                                iVarFieldId1 = 0;    //  For the variable defined in external table(case of offline table).
                            }
                        }
                    }
                    //      Operating for Param2    -----------------------------------------------

                    int iVariableId2 = parser3.getIntOf("VariableId2", 0, true);
                    int iVarFieldId2 = parser3.getIntOf("VarFieldId2", 0, true);
                    int iExtObjId2 = 0;
                    //  Case when variableId and varFieldId is provided.
                    if(!(iVariableId2 == 0 && iVarFieldId2 == 0)){
                        WFVariabledef attributeMap = (WFVariabledef)CachedObjectCollection.getReference().getCacheObject(con, strEngineName, iProcessDefId, WFSConstant.CACHE_CONST_Variable, "" + 0).getData();
                        for(int iCounter = 1; iCounter <= attributeMap.getAllFieldInfoMap().size(); iCounter ++){
                            if(attributeMap.getAllFieldInfoMap().containsKey((iVariableId2 + string21 + iVarFieldId2).toUpperCase())){
                                WFFieldInfo wfFieldInfo = (WFFieldInfo)attributeMap.getAllFieldInfoMap().get((iVariableId2 + string21 + iVarFieldId2).toUpperCase());
                                strLeafParam2 = wfFieldInfo.getName();
                                cType2 = wfFieldInfo.getScope();
                                iExtObjId2 = wfFieldInfo.getExtObjId();
                            }
                        }
                    } else {    //  Case when variableId and varFieldId are not provided(Case of Constant or null).
                        String strParam2 = parser3.getValueOf("Param2", "", true);
                        strLeafParam2 = strParam2;       //  Parameter to be finally inserted into the table.
                        if (strParam2.contains(".")) {
                            strLeafParam2 = strParam2.substring(strParam2.lastIndexOf(".") + 1);
                        }
                        strFetchedParameter = strParam2;
                        cType2 = parser3.getValueOf("Type2", "", false).charAt(0);
                        if (String.valueOf(cType2).equalsIgnoreCase("V") || String.valueOf(cType2).equalsIgnoreCase("C")) {     //  Param2 can be Constant or Null.
                            iVariableId2 = 0;
                            iVarFieldId2 = 0;
                        } else {
                            if (strParam2.contains(".")) //  In case of complex types, we have variables like A.B.C. Here we fetch A
                            {
                                strFetchedParameter = strParam2.substring(0, strParam2.indexOf("."));
                            }
                            rs = stmt.executeQuery("Select ExtObjId, VariableId from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + iProcessDefId + " and UserDefinedName ="+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + " and VariableScope = "+ WFSUtil.TO_STRING(Character.toString(cType2), true, dbType) + "");
                            /*System.out.println("Select ExtObjId, VariableId from VarMappingTable where ProcessDefId = " + iProcessDefId + " and UserDefinedName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + " and VariableScope = "+ WFSUtil.TO_STRING(Character.toString(cType2), true, dbType) + "");*/
                            while (rs != null && rs.next()) {   //  Fetching the external Object Id for the variable
                                iExtObjId2 = rs.getInt(1);
                                iVariableId2 = rs.getInt(2);
                                break;
                            }
                            if (iExtObjId2 != 0) {    //  If the variable in external table is mapped to a user defined variable(case of complex type).
                                if (strParam2.contains(".")) //  In case of complex types, we have variables like A.B.C. Here we fetch C
                                {
                                    strFetchedParameter = strParam2.substring(strParam2.lastIndexOf(".") + 1);
                                }
                                rs = stmt.executeQuery("Select VarFieldId from WFUDTVarmappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = " + iProcessDefId + " and ExtObjId = " + iExtObjId2 + " and VariableId = " + iVariableId2 + " and MappedObjectName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + "");
                                /*System.out.println("Select VarFieldId from WFUDTVarmappingTable where ProcessDefId = " + iProcessDefId + " and ExtObjId = " + iExtObjId2 + " and VariableId = " + iVariableId2 + " and MappedObjectName = "+ WFSUtil.TO_STRING(strFetchedParameter, true, dbType) + "");*/
                                while (rs != null && rs.next()) {   //  Fetching the external Object Id for the variable
                                    iVarFieldId2 = rs.getInt(1);
                                    break;
                                }
                            } else {
                                iVarFieldId2 = 0;    //  For the variable defined in external table(case of offline table).
                            }
                        }
                    }

                    //  Inserting the data retrieved into the WFExtInterfaceConditionTable
                    stmt.executeQuery("Insert into WFExtInterfaceConditionTable(ProcessDefId, ActivityId, InterfaceType," +
                            " RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, Param2, Type2, ExtObjID2, " +
                            "Operator, LogicalOp, VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2) values (" + iProcessDefId +
                            ", " + 0 + ", N'T', " + iMaxRuleId + ", " + iMaxRuleId + ", " + iConditionOrderId + ", "+ WFSUtil.TO_STRING(strLeafParam1, true, dbType) + ", "+ WFSUtil.TO_STRING(Character.toString(cType1), true, dbType) + ", " + iExtObjId1 + ", "+ WFSUtil.TO_STRING(strLeafParam2, true, dbType) + ", "+ WFSUtil.TO_STRING(Character.toString(cType2), true, dbType) + ", " +
                            iExtObjId2 + ", " + iOperator + ", " + iLogicalOperator + ", " + iVariableId1 + ", " +
                            iVarFieldId1 + ", " + iVariableId2 + ", " + iVarFieldId2 + ")");
					/*System.out.println("Insert into WFExtInterfaceConditionTable(ProcessDefId, ActivityId, InterfaceType," +
                            " RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, Param2, Type2, ExtObjID2, " +
                            "Operator, LogicalOp, VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2) values (" + iProcessDefId +
                            ", " + 0 + ", N'T', " + iMaxRuleId + ", " + iMaxRuleId + ", " + iConditionOrderId + ", "+ WFSUtil.TO_STRING(strLeafParam1, true, dbType) + ", "+ WFSUtil.TO_STRING(Character.toString(cType1), true, dbType) + ", " + iExtObjId1 + ", "+ WFSUtil.TO_STRING(strLeafParam2, true, dbType) + ", "+ WFSUtil.TO_STRING(Character.toString(cType2), true, dbType) + ", " +
                            iExtObjId2 + ", " + iOperator + ", " + iLogicalOperator + ", " + iVariableId1 + ", " +
                            iVarFieldId1 + ", " + iVariableId2 + ", " + iVarFieldId2 + ")");*/
                }

                //  Operating on Rule Operation..
                parser2.setInputXML(strToDoListDefinition);
                String strRuleOperationXML = parser2.getValueOf("RuleOperation");
                int iInterfaceIdCount = parser2.getNoOfFields("InterfaceElementId");
                int iInterfaceElementId = 0;
                parser2.setInputXML(strRuleOperationXML);
                for (int j = 1; j <= iInterfaceIdCount; j++) {
                    if (j == 1) {
                        iInterfaceElementId = Integer.parseInt(parser2.getFirstValueOf("InterfaceElementId"));
                    } else {
                        iInterfaceElementId = Integer.parseInt(parser2.getNextValueOf("InterfaceElementId"));
                    }
                    stmt.execute("Insert into WFExtInterfaceOperationTable(ProcessDefId, ActivityId, InterfaceType," +
                            " RuleId, InterfaceElementId) values (" + iProcessDefId +
                            ", " + 0 + ", N'T', " + iMaxRuleId + ", " + iInterfaceElementId + ")");
                    /*System.out.println("Insert into WFExtInterfaceOperationTable(ProcessDefId, ActivityId, InterfaceType," +
                            " RuleId, InterfaceElementId) values (" + iProcessDefId +
                            ", " + 0 + ", N'T', " + iMaxRuleId + ", " + iInterfaceElementId + ")");*/
                }
            }
            if (mainCode == 0) {
                strReturnXML.append("<WFSetToDoListMetadata_Output>");
                strReturnXML.append("<Exception>");
                strReturnXML.append(gen.writeValueOf("Maincode", String.valueOf(mainCode)));
                strReturnXML.append("</Exception>");
                strReturnXML.append("</WFSetToDoListMetadata_Output>");
                if (bCreateTransaction) {
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
            } else {
                descr = e.getMessage();
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
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (bCreateTransaction) {
                    if (!con.getAutoCommit()) {
                        con.rollback();
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception e) {
                    WFSUtil.printErr(engine,"WFToDoListClass>> setExternalInterfaceRules" + e);
            }

            if (mainCode != 0) {
                strReturnXML.append("<WFSetToDoListRules_Output>");
                WFSException objException = new WFSException(mainCode, subCode, errType, subject, descr);
                strReturnXML.append(objException.getMessage());
                strReturnXML.append("</WFSetToDoListRules_Output>");
            }
        }
        return strReturnXML.toString();
    }
} // class WFExternalInterface
