// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application �Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFActionClass.java
//	Author						: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description					: Implementation of Action External Interface.
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
// 01/10/2002			Prashant		 change for using cached trigger definition
// 24/03/2003			Prashant		 Bug No TSR_3.0.1_004
// 18/05/2005           Ashish Mangla	 Changes for automatic cache updation
//  2/08/2005           Mandeep Kaur	 SrNo-1(Bug Ref # WFS_5_040).
// 15/03/2007			Ashish Mangla	 Bugzilla Bug 471 (On checkout-checkin of route, action data was not getting returned)
// 04/05/2007           Shilpi           ActionCalFlag added (for calendar support)
// 18/10/2007			Varun Bhansaly	 SrNo-2, Use WFSUtil.printXXX instead of System.out.println()
//										 System.err.println() & printStackTrace() for logging.
// 19/11/2007			Varun Bhansaly	 WFSUtil.getBIGData() to be used instead getBinaryStream
// 21/12/2007			Ashish Mangla	 Bugzilla Bug 2817 (Tag <EncodedBinaryData> should now be sent on the basis of isEnctrypted column)
// 02/09/2008			Shweta Tyagi	 SrNo-3  Added VariableId and VarFieldId to provide Complex Data Type Support
// 13/03/2009			Ashish Mangla	 Bugzilla Bug 7763 (Action should be come in order of actionid)
// 27/04/2011			Ashish Mangla	As column type of OID coplumn has been changed to Text, No need to use LargeObjectAPI for Postgres. No need to open transaction in that case.
// 05/07/2012           Bhavneet Kaur    Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import com.newgen.omni.jts.cache.WFTrigger;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.srvr.*;

public class WFActionClass
  extends WFExternalInterface {

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	getExternalData
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator , ProcessDefId , ActivityId , ProcessInstanceId , WorkItemID
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:   gets the Actions , Operations and Triggers associated with
//											an Activity and ProcessDefId .
//----------------------------------------------------------------------------------------------------
	public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{

	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
	String processInst = parser.getValueOf("ProcessInstanceID");
	int workItem = parser.getIntOf("WorkItemID", 0, true);
	char defnFlag = parser.getCharOf("DefinitionFlag", 'Y', true);
	int dbType = ServerProperty.getReference().getDBType(engine);
	StringBuffer actionXml = new StringBuffer(100);
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;
	Object[] result = null;
	ResultSet rs = null;
   //*********************************************************************************************
   // changed by	:	Mandeep Kaur
   // Reason/Cause  :   Action is not working properly in case of muliple action and Multiple rules
   // Ref No        :   SrNo-1
   //**********************************************************************************************
	try {
		if(processDefId != 0 && activityId != 0 && (defnFlag == 'Y' || isCacheExpired(con, parser))) {	//Bugzilla Bug 471
				pstmt = con.prepareStatement("select ActionId,ActionName,ViewAs from actiondeftable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityId = ? and ProcessDefId = ?  ORDER by ActionId ASC");
				pstmt.setInt(1, activityId);
				pstmt.setInt(2, processDefId);
				pstmt.execute();
				rs = pstmt.getResultSet();
				// use arrayList in place of vector - Ruhi - August 4th
				Vector vectActions = new Vector();
		        int trigger = 0;
		        String tempStr = "";

				while(rs != null && rs.next()){
					action act = new action();
					act.iActionId = rs.getInt("ActionId");
					act.strActionName = rs.getString("ActionName");
					act.strViewAs = rs.getString("ViewAs");
			        vectActions.add(act);

				}
				if(rs != null){
					rs.close(); rs = null;
				}
				pstmt.close(); pstmt = null;
		
				actionXml.append("<Actions>\n");
				StringBuffer triggers = new StringBuffer();
				StringBuffer actionids = new StringBuffer("0");


				for(int iCount = 0; iCount < vectActions.size(); ++iCount)
				{
					action act = (action) vectActions.get(iCount);
					actionXml.append("<Action>\n");
					actionXml.append(gen.writeValueOf("ActionIndex", String.valueOf(act.iActionId)));
					actionXml.append(gen.writeValueOf("ActionName", act.strActionName));
					actionXml.append(gen.writeValueOf("ActionViewAs", act.strViewAs));
					actionids.append("," + act.iActionId);
					actionXml.append("<icon>" + act.iActionId +"</icon>");
					//SrNo-3
					pstmt = con.prepareStatement("select Operator,Param1,Param2,LogicalOp,Type1,Type2, VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 from ActionConditionTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ActivityId = ? and ProcessDefId = ?  and RuleID = ?");
					pstmt.setInt(1, activityId);
					pstmt.setInt(2, processDefId);
					pstmt.setInt(3, act.iActionId);
					pstmt.execute();
					rs = pstmt.getResultSet();
				    actionXml.append("<Rules>\n");
		            actionXml.append("<Rule>\n");
		            actionXml.append("<RuleConditions>\n");
					// give column name in getString/ getInt... rather than 1, 2, 3, - Ruhi - August 4th
					while(rs != null && rs.next()){
			            actionXml.append("<RuleCondition>\n");
						actionXml.append(gen.writeValueOf("Operator", rs.getString("Operator")));
						actionXml.append(gen.writeValueOf("Operand1", rs.getString("Param1")));
						actionXml.append(gen.writeValueOf("Operand2", rs.getString("Param2")));
						actionXml.append(gen.writeValueOf("LogFlag", rs.getString("LogicalOp")));
						actionXml.append(gen.writeValueOf("Type1", rs.getString("Type1")));
						actionXml.append(gen.writeValueOf("Type2", rs.getString("Type2")));
						//SrNo-3
						actionXml.append(gen.writeValueOf("VariableId1", rs.getString("VariableId_1")));
						actionXml.append(gen.writeValueOf("VariableId2", rs.getString("VariableId_2")));
			            actionXml.append(gen.writeValueOf("VarFieldId1", rs.getString("VarFieldId_1")));
						actionXml.append(gen.writeValueOf("VarFieldId2", rs.getString("VarFieldId_2")));
			            actionXml.append("</RuleCondition>\n");
					}
		            actionXml.append("</RuleConditions>\n");
					if(rs != null){
						rs.close(); rs = null;
					}
					pstmt.close(); pstmt = null;
					//query changed by shilpi for calendar support
					//SrNo-3
					pstmt = con.prepareStatement("select OperationOrderID,OperationType,Param1,Param2,Type1,Type2,Param3,Type3,VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, Operator, ActionCalFlag from ActionOperationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ActivityId = ? and ProcessDefId = ?  and RuleID = ?");
					pstmt.setInt(1, activityId);
					pstmt.setInt(2, processDefId);
					pstmt.setInt(3, act.iActionId);
					pstmt.execute();
					rs = pstmt.getResultSet();
		            actionXml.append("<RuleActions>\n");
					while(rs.next())
					{
			            actionXml.append("<RuleAction>\n");
			            actionXml.append(gen.writeValueOf("OperatorIndex", String.valueOf(rs.getInt("OperationOrderID"))));
			            trigger = rs.getInt("OperationType");
				        actionXml.append(gen.writeValueOf("Operator", String.valueOf(trigger)));
			            tempStr = rs.getString("Param1");
			            tempStr = (!rs.wasNull() && trigger == WFSConstant.ACTION_TRIGGER)? "�" + tempStr.trim() + "�" : gen.writeValueOf("Operand1", tempStr);
			            actionXml.append(tempStr);
				        if(trigger == WFSConstant.ACTION_TRIGGER) 
			              triggers.append(tempStr);
						//SrNo-3
						actionXml.append(gen.writeValueOf("Type1", rs.getString("Type1")));
						actionXml.append(gen.writeValueOf("VariableId1", rs.getString("VariableId_1")));
						actionXml.append(gen.writeValueOf("VarFieldId1", rs.getString("VarFieldId_1")));
						actionXml.append(gen.writeValueOf("Operand2", rs.getString("Param2")));
						actionXml.append(gen.writeValueOf("Type2", rs.getString("Type2")));
						actionXml.append(gen.writeValueOf("VariableId2", rs.getString("VariableId_2")));
						actionXml.append(gen.writeValueOf("VarFieldId2", rs.getString("VarFieldId_2")));
						actionXml.append(gen.writeValueOf("Operand3", rs.getString("Param3")));
						actionXml.append(gen.writeValueOf("Type3", rs.getString("Type3")));
						actionXml.append(gen.writeValueOf("VariableId3", rs.getString("VariableId_3")));
						actionXml.append(gen.writeValueOf("VarFieldId3", rs.getString("VarFieldId_3")));
						actionXml.append(gen.writeValueOf("ExprOperator", rs.getString("Operator")));
		                //appended by shilpi for calendar support
						actionXml.append(gen.writeValueOf("ActionCalFlag", rs.getString("ActionCalFlag")));
						actionXml.append("\n</RuleAction>\n");
					}

					rs.close(); rs = null;
					pstmt.close(); pstmt = null;
		            actionXml.append("</RuleActions>\n");
				    actionXml.append("</Rule>\n");
		            actionXml.append("</Rules>\n");
		            actionXml.append("</Action>\n");

				}
		        actionXml.append("</Actions>\n");
//----------------------------------------------------------------------------
// Changed By				: Prashant
// Reason / Cause (Bug No if Any)	: change for using cached trigger definition
// Change Description			:	use cache trigger definitions rather than querying on each call
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: for Automatic Cache updation
// Change Description				: Used Singleton class CachedObjectCollection
//----------------------------------------------------------------------------
        String srcXML = actionXml.toString();
        java.util.StringTokenizer st = new java.util.StringTokenizer(triggers.toString(), "�");
        while(st.hasMoreTokens()) {
          String trgr_name = st.nextToken();
          String trgr_def = (String)CachedObjectCollection.getReference().getCacheObject(con,engine,processDefId, WFSConstant.CACHE_CONST_Trigger,trgr_name).getData();
            srcXML = WFSUtil.replace(srcXML, "�" + trgr_name + "�", trgr_def);
        }

//----------------------------------------------------------------------------
// Changed By				: Prashant
// Reason / Cause (Bug No if Any)	: TSR_3.0.1_004
// Change Description			:	change for fetching IconBuffers
//----------------------------------------------------------------------------
		/* Transaction opened especially for reading PostgreSQL LargeObjects
		 * -Varun Bhansaly
		 */
		/* Transaction no more needed as column type has been changed to TEXT FROM OID
		*/
/*		if(con.getAutoCommit()){
			con.setAutoCommit(false);
		}
*/	
        pstmt = con.prepareStatement(
          "Select IconBuffer , ActionID, isEncrypted from ActionDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where ActionID in (" + actionids
          + ") and ProcessDefid = ? and ActivityId = ? ORDER by ActionID ASC");
        pstmt.setInt(1, processDefId);
        pstmt.setInt(2, activityId);
        pstmt.execute();
        rs = pstmt.getResultSet();
        int i = 0;
		String encodedBinaryData = null;
        while(rs.next()) {
          actionXml = new StringBuffer("<ActionIcon>");
		  result = WFSUtil.getBIGData(con, rs, "IconBuffer", dbType, "8859_1");
		  actionXml.append((String)result[0]);
          actionXml.append("</ActionIcon>");
          srcXML = WFSUtil.replace(srcXML, "<icon>" + rs.getInt("ActionID") + "</icon>", actionXml.toString());
		  encodedBinaryData = rs.getString("isEncrypted");	//Bugzilla Bug 2817
		  encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
//          srcXML = WFSUtil.replace(srcXML, "�" + rs.getInt(2) + "�", actionXml.toString());
//					java.io.FileOutputStream temp = new java.io.FileOutputStream("ac_pr_"+processDefId+"_act_"+activityId+"_"+(++i)+".gif");
//          temp.write(actionXml.toString().getBytes("8859_1"));
//          temp.close();
        }
		//
		//	Tag Added after checking for the charSet
		//	Required by web client 
		//  - Ruhi Hira 
		//
		//	if(!(com.newgen.omni.jts.srvr.DatabaseTransactionServer.charSet.equalsIgnoreCase("ISO8859_1")))
		//		srcXML = srcXML + "<EncodedBinaryData>Y</EncodedBinaryData>";
			srcXML += gen.writeValueOf("EncodedBinaryData", encodedBinaryData);
			actionXml = new StringBuffer("<ActionInterface><Definition>" + srcXML
			  + "</Definition></ActionInterface>");
			rs.close(); rs = null; // ref no 1
		}
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";											
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
		/*try{
	        if(!con.getAutoCommit()){
				con.setAutoCommit(true);
	        }
		}catch(SQLException sqle){}*/ //Transaction no more needed as column type has been changed to TEXT FROM OID
		try{
			if(rs != null){
				rs.close();
				rs = null;
			}
		}catch(SQLException sqle){}
		try {
			if(pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
		} catch(Exception e) {}
      if(mainCode != 0) {
       WFSUtil.printOut(engine,gen.writeError("WFGetAction", mainCode, subCode, errType,
          WFSErrorMsg.getMessage(mainCode), descr));
      }
    }
      return actionXml.toString();
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	WMSetAction
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
  public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException{
	  
	String engine = parser.getValueOf("EngineName", "", false);
	int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
	int activityId = parser.getIntOf("ActivityID", 0, true);
	String processInst = parser.getValueOf("ProcessInstanceID");
	int workItem = parser.getIntOf("WorkItemID", 0, true);
	String userName = parser.getValueOf("Username", "System", true);
	int userID = parser.getIntOf("Userindex", 0, true);
	int dbType = ServerProperty.getReference().getDBType(engine);
	StringBuffer actionXml = new StringBuffer(100);
    PreparedStatement pstmt = null;
    int mainCode = 0;
    int subCode = 0;
    String subject = null;
    String descr = null;
    String errType = WFSError.WF_TMP;

    try {
      int nooffields = parser.getNoOfFields("Action");
      if(nooffields > 0) {
        pstmt = con.prepareStatement(
          " Select ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ? ");
        pstmt.setInt(1, processDefId);
        pstmt.setInt(2, activityId);
        pstmt.execute();
        ResultSet rs = pstmt.getResultSet();
        String actName = "";

        if(rs.next()) {
          actName = rs.getString(1);

          int start = 0;
          int end = 0;

          rs.close();
          pstmt.close();

          for(int i = 0; i < nooffields; i++) {
            start = parser.getStartIndex("Action", end, 0);
            end = parser.getEndIndex("Action", start, 0);

            int ActionIndex = Integer.parseInt(parser.getValueOf("ActionIndex", start, end));
            String operand1 = parser.getValueOf("ActionName", start, end);
            /*
                  switch (ActionIndex)
                  {
                     case WFSConstant.ACTION_INCPRIORITY:
                     ActionIndex =  WFSConstant.WFL_Priority_Incremented ;
                    break;
                     case WFSConstant.ACTION_DECPRIORITY:
                     ActionIndex =  WFSConstant.WFL_Priority_Decremented ;
                    break;
                     case WFSConstant.ACTION_SUBMIT	:
                     ActionIndex =  WFSConstant.WFL_Submit ;
                    break;
                     case WFSConstant.ACTION_RELEASE	:
                     ActionIndex =  WFSConstant.WFL_Release ;
                    break;
                     case WFSConstant.ACTION_TRIGGER:
                     ActionIndex	=  WFSConstant.WFL_Trigger ;
                     operand1	= parser.getValueOf("TriggerName", start, end);
                    break;
                   default:
                     ActionIndex	 =  WFSConstant.WFL_ActionPerformed;
                  }
             */if(ActionIndex > 0) {
				  WFSUtil.generateLog(engine, con, WFSConstant.WFL_ActionPerformed, processInst, workItem, processDefId, activityId, actName, 
					0, userID, userName, ActionIndex, operand1, null, null, null, null);
            }
          }
        } else {
          rs.close();
          pstmt.close();
        }
        actionXml = new StringBuffer(100);
        actionXml.append("<WFSetAction_Output>\n");
        actionXml.append("<Exception>\n<SubCode>0</SubCode>\n</Exception>\n");
        actionXml.append("</WFSetAction_Output>");
      }
    } catch(SQLException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WM_INVALID_FILTER;
      subCode = WFSError.WFS_SQL;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_FAT;
      if(e.getErrorCode() == 0) {
        if(e.getSQLState().equalsIgnoreCase("08S01")) {
          descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
            + ")";
        }
      } else {
        descr = e.getMessage();
      }
    } catch(NumberFormatException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_ILP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(NullPointerException e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_SYS;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Exception e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } catch(Error e) {
      WFSUtil.printErr(engine,"", e);
      mainCode = WFSError.WF_OPERATION_FAILED;
      subCode = WFSError.WFS_EXP;
      subject = WFSErrorMsg.getMessage(mainCode);
      errType = WFSError.WF_TMP;
      descr = e.toString();
    } finally {
      try {
        if(pstmt != null) {
          pstmt.close();
          pstmt = null;
        }
      } catch(Exception e) {}
      if(mainCode != 0) {
        actionXml = new StringBuffer(100);
        actionXml.append("<WFSetAction_Output>\n");
        actionXml.append("<Exception>\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr
          + "</Description>\n</Exception>\n");
        actionXml.append("</WFSetAction_Output>\n");
      }
    }
    return actionXml.toString();
  }
// SrNo-1  By mandeep
class action
{
  public int iActionId;
  public String strActionName;
  public String strViewAs;
}
} // class WFActionClass