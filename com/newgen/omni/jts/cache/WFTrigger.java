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
// 20/08/2004			Ruhi Hira			CacheTime related changes
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
// 28/07/2006			Ashish Mangla		Bugzilla Id 47 - RTrim( ? )
// 03/08/2006           Ruhi Hira           Bugzilla Id 46.
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 19/11/2007			Varun Bhansaly		WFSUtil.getBIGData() signature changed
// 02/09/2008			Shweta Tyagi	    SrNo-2  Added VariableId and VarFieldId to provide Complex 
//										    Data Type Support
// 05/11/2008			Ashish Mangla		Bugzilla Bug 6900 (ArgList should be defined while defining template (PFE can also use same arglist))
// 06/12/2008           Shweta Tyagi        Bugzilla Bug 7175
// 01/07/2009           Saurabh Kamal       SrNo-3 Removal of unnecessary <Trigger> tag appended in trigger xml.
// 24/04/2012           Bhavneet Kaur       Bug 31160: Supprort of defining format of Template to be gererated(Pdf/Doc).
// 05/07/2012         	Bhavneet Kaur     	Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 27/05/2014           Kanika Manik        PRD Bug 42494 - BCC support at each email sending modules
// 28/05/2014           Anwar Danish        PRD Bug 42795 merged - Activity wise customization of sending mail priority
// 14/05/2018			Ambuj Tripathi		PRD Bug 73436 - Support for various type of template in generate response of PFE utility. Generate response code will be common to PFE and Webdesktop as well. 
//22/05/2018			AMbuj Tripathi		Reverting PRD Bug 77201 changes
//29/10/2020			Mohnish Chopra		Bug 95725 - iBPS 4.0 SP1 : Support for various type of template in generate response of PFE utility and Handling of Locale for Templates
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.util.HashMap;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;

import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.triggers.WFTriggerInterface;
import com.newgen.omni.jts.srvr.DatabaseTransactionServer;

public class WFTrigger extends cachedObject{

    XMLGenerator gen;
    String key;
    public String xml;

    protected void setEngineName(String engineName){
        this.engineName = engineName;
    }

    protected void setProcessDefId(int processDefId){
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
    protected Object create(Connection con, String key){

        int dbType = ServerProperty.getReference().getDBType(engineName);
        String triggername = key.trim();	//Bugzilla Id 47 Added trim

        StringBuffer tempXml = new StringBuffer("<Trigger>\n");
        PreparedStatement pstmt = null;
        ResultSet rs=null;
        gen = new XMLGenerator();

        try{
            pstmt = con.prepareStatement("Select TriggerID , TriggerName , TriggerType , TriggerTypeName from TriggerDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where rtrim(TriggerName) = ? and Processdefid = ? ");	//Bugzilla Id 47 Removed rtrim
            WFSUtil.DB_SetString(1, triggername, pstmt, dbType);
            pstmt.setInt(2, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(rs.next()){
                int triggerID = rs.getInt(1);
                tempXml.append(gen.writeValueOf("TriggerIndex", String.valueOf(triggerID)));
                String trgr_name = rs.getString(2);
                tempXml.append(gen.writeValueOf("TriggerName", trgr_name));
                trgr_name = rs.getString(3);
                char trgr_type = rs.wasNull() ? '\0' : trgr_name.charAt(0);
                tempXml.append(gen.writeValueOf("TriggerType", String.valueOf(trgr_type)));
                String trgrtypename = rs.getString(4);
                tempXml.append(gen.writeValueOf("TriggerTypeName", trgrtypename));
                rs.close();

                switch(trgr_type){
                    case 'X':
                        try{
                            WFTriggerInterface trg = (WFTriggerInterface) Class.forName(
                                "com.newgen.omni.jts.triggers.clsExceptionTrigger").newInstance();
                            tempXml.append(trg.getTriggerData(con, gen, processDefId, dbType, triggerID));
                        } catch(Exception e){
                            WFSUtil.printErr(engineName,"", e);
                        }
                        case 'U':
                            pstmt = con.prepareStatement("Select ClassName , ExecutableClass , Httppath from TriggerTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where TypeName = ? and Processdefid = ? ");
//              pstmt.setString(1, trgrtypename);
                            WFSUtil.DB_SetString(1, trgrtypename, pstmt, dbType);
                            pstmt.setInt(2, processDefId);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if(rs.next()){
                                String classname = rs.getString(1);
                                tempXml.append(gen.writeValueOf("ExecutableClass", rs.getString(2)));
                                tempXml.append(gen.writeValueOf("Httppath", rs.getString(3)));
                                rs.close();
                                try{
                                    WFTriggerInterface trg = (WFTriggerInterface) Class.forName(classname).
                                        newInstance();
                                    tempXml.append(trg.getTriggerData(con, gen, processDefId, dbType, triggerID));
                                } catch(Exception e){
                                    WFSUtil.printErr(engineName,"", e);
                                }
                            }
                            break;
                    default:
                        //SrNo-2
						pstmt = con.prepareStatement(
                            "Select ExtObjIDTo, VariableIdTo, VarFieldIdTo, ExtObjIDCC, VariableIdCC, VarFieldIdCC, ToType, "
							+ "CCType, Subject, ToUser, CCUser, Message, FunctionName, ExtObjID , VariableId, VarFieldId, "
							+ "Type ,VariableName, f.ApplicationName , f.ArgList as Largs, Param1, Type1, ExtObjID1 , "
							+ "VariableId_1, VarFieldId_1, Param2 , Type2, ExtObjID2 , VariableId_2, VarFieldId_2, "
							+ "FileName ,InputFormat, k.ApplicationName as Kapp, k.ArgList as RList , c.ArgList , GenDocType , "
							+ "FROMUSER , VariableIdFrom, VarFieldIdFrom, FROMUSERTYPE , C.HTTPPATH, k.format, BCCUser, BCCType, ExtObjIDBCC, VariableIdBCC, VarFieldIdBCC, MailPriority, VariableIdMailPriority, VarFieldIdMailPriority, MailPriorityType from TriggerDefTable a " + WFSUtil.getTableLockHintStr(dbType)
							+ " LEFT OUTER JOIN MailTriggerTable b " + WFSUtil.getTableLockHintStr(dbType) + " ON b.TriggerID = a.TriggerID and b.ProcessDefID = a.ProcessDefID "
							+ "LEFT OUTER JOIN ExecuteTriggerTable c " + WFSUtil.getTableLockHintStr(dbType) + " ON c.TriggerID = a.TriggerID and c.ProcessDefID = a.ProcessDefID "
							+ "LEFT OUTER JOIN DataEntryTriggerTable d " + WFSUtil.getTableLockHintStr(dbType) + " ON d.TriggerID = a.TriggerID and d.ProcessDefID =a.ProcessDefID "
							+ "LEFT OUTER JOIN DataSetTriggerTable e " + WFSUtil.getTableLockHintStr(dbType) + " ON e.TriggerID = a.TriggerID and e.ProcessDefID = a.ProcessDefID "
							+ "LEFT OUTER JOIN LaunchAppTriggerTable f " + WFSUtil.getTableLockHintStr(dbType) + " ON f.TriggerID = a.TriggerID and f.ProcessDefID = a.ProcessDefID "
							+ "LEFT OUTER JOIN (Select GenerateResponseTable.ProcessDefID, TriggerID, ApplicationName, TemplateDefinitionTable.ArgList, FileName, GenDocType,InputFormat, TemplateDefinitionTable.format from GenerateResponseTable " + WFSUtil.getTableLockHintStr(dbType) + ", "
								+ " TemplateDefinitionTable " + WFSUtil.getTableLockHintStr(dbType) + " where TemplateDefinitionTable.ProcessDefId = GenerateResponseTable.ProcessDefId and FileName = TemplateFileName ) k ON k.TriggerID = a.TriggerID and k.ProcessDefID =a.ProcessDefID "
							+ " where a.TriggerName = ? and a.ProcessDefID = ?");
//            }
//            pstmt.setString(1, triggername);
                        WFSUtil.DB_SetString(1, triggername, pstmt, dbType);
                        pstmt.setInt(2, processDefId);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
						//SrNo-3
                        while(rs.next()){
                            tempXml.append("<TriggerAttributes>");
                            tempXml.append(gen.writeValueOf("ExternalObjectIdTo", rs.getString(1)));
                            //SrNo-2
							tempXml.append(gen.writeValueOf("VariableIdTo", rs.getString(2)));
							tempXml.append(gen.writeValueOf("VarFieldIdTo", rs.getString(3)));
							tempXml.append(gen.writeValueOf("ExternalObjectIdCC", rs.getString(4)));
		                    tempXml.append(gen.writeValueOf("VariableIdCC", rs.getString(5)));
							tempXml.append(gen.writeValueOf("VarFieldIdCC", rs.getString(6)));
							tempXml.append(gen.writeValueOf("ToType", rs.getString(7)));
                            tempXml.append(gen.writeValueOf("CCType", rs.getString(8)));
                            tempXml.append(gen.writeValueOf("Subject", rs.getString(9)));
                            tempXml.append(gen.writeValueOf("ToUser", rs.getString(10)));
                            tempXml.append(gen.writeValueOf("CCUser", rs.getString(11)));
                            /**
                             * 03/08/2006, Bugzilla Id 46. - Ruhi Hira
                             */
                            Object[] result = WFSUtil.getBIGData(con, rs, "Message", dbType, DatabaseTransactionServer.charSet);
                            tempXml.append("<Message>");
                            tempXml.append((String)result[0]);
                            tempXml.append("</Message>");
                            tempXml.append(gen.writeValueOf("FunctionName", rs.getString(13)));
                            tempXml.append(gen.writeValueOf("TriggerExternalObjectIndex", rs.getString(14)));
	                        //SrNo-2
							tempXml.append(gen.writeValueOf("DataEntryTriggerVariableId", rs.getString(15)));
							tempXml.append(gen.writeValueOf("DataEntryTriggerVarFieldId", rs.getString(16)));
                            tempXml.append(gen.writeValueOf("DataEntryTriggerType", rs.getString(17)));
                            tempXml.append(gen.writeValueOf("DataEntryTriggerVariableName", rs.getString(18)));
                            tempXml.append(gen.writeValueOf("ApplicationName", rs.getString(19)));
                            tempXml.append(gen.writeValueOf("ArgumentList", rs.getString(20)));
                            tempXml.append(gen.writeValueOf("DataSetVar1", rs.getString(21)));
                            tempXml.append(gen.writeValueOf("DataSetType1", rs.getString(22)));
                            tempXml.append(gen.writeValueOf("DataSetExtObjID1", rs.getString(23)));
	                        //SrNo-2
							tempXml.append(gen.writeValueOf("DataSetVariableID1", rs.getString(24)));
							tempXml.append(gen.writeValueOf("DataSetVarFieldID1", rs.getString(25)));
                            tempXml.append(gen.writeValueOf("DataSetParam2", rs.getString(26)));
                            tempXml.append(gen.writeValueOf("DataSetType2", rs.getString(27)));
                            tempXml.append(gen.writeValueOf("DataSetExtObjID2", rs.getString(28)));
    						tempXml.append(gen.writeValueOf("DataSetVariableID2", rs.getString(29)));
							tempXml.append(gen.writeValueOf("DataSetVarFieldID2", rs.getString(30)));
							tempXml.append(gen.writeValueOf("FileName", rs.getString(31)+"."+rs.getString(32)));
                            tempXml.append(gen.writeValueOf("GenAppName", rs.getString(33)));
                            tempXml.append(gen.writeValueOf("GenArgList", rs.getString(34)));
                            tempXml.append(gen.writeValueOf("ArgList", rs.getString(35)));
                            tempXml.append(gen.writeValueOf("GenDocType", rs.getString(36)));
                            tempXml.append(gen.writeValueOf("FromUser", rs.getString(37)));
                            tempXml.append(gen.writeValueOf("VariableIdFromUser", rs.getString(38)));//Bugzilla Bug 7175
                            tempXml.append(gen.writeValueOf("VarFieldIdFromUser", rs.getString(39)));////Bugzilla Bug 7175
							tempXml.append(gen.writeValueOf("FromType", rs.getString(40)));;
                            tempXml.append(gen.writeValueOf("HTTPPath", rs.getString(41)));
                            tempXml.append(gen.writeValueOf("Format", rs.getString(42)));
                            tempXml.append(gen.writeValueOf("BCCUser", rs.getString(43)));
                            tempXml.append(gen.writeValueOf("BCCType", rs.getString(44)));
                            tempXml.append(gen.writeValueOf("ExternalObjectIdBCC", rs.getString(45)));
                            tempXml.append(gen.writeValueOf("VariableIdBCC", rs.getString(46)));
                            tempXml.append(gen.writeValueOf("VarFieldIdBCC", rs.getString(47)));
							tempXml.append(gen.writeValueOf("MailPriority", rs.getString(48)));
                            tempXml.append(gen.writeValueOf("VariableIdMailPriority", rs.getString(49)));
                            tempXml.append(gen.writeValueOf("VarFieldIdMailPriority", rs.getString(50)));
                            tempXml.append(gen.writeValueOf("MailPriorityType", rs.getString(51)));
                            tempXml.append("</TriggerAttributes>\n");
                        }
                }
            }
        } catch(SQLException e){
            WFSUtil.printErr(engineName,"", e);
        } catch(java.io.IOException e){
            WFSUtil.printErr(engineName,"", e);
        } catch(Exception e){
            WFSUtil.printErr(engineName,"", e);
        } finally{
        	try{
            	if(rs!=null){
            		rs.close();
            		rs=null;
            	}
            } catch(Exception e){}
            try{
            	if(pstmt!=null){
            		pstmt.close();
            		pstmt=null;
            	}
            } catch(Exception e){}
        }
        tempXml.append("</Trigger>\n");
        xml = tempXml.toString();
        return xml;
    }
}