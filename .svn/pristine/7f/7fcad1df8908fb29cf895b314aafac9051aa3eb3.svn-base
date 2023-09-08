// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Omniflow Server
//	File Name				: WFFormExtClass.java
//	Author					: Shweta Singhal
//	Date written (DD/MM/YYYY)	: 16/09/2013
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//	23/07/2018		Ambuj Tripathi			Bug 79311 - OFServer: Getting error while creating WI of variant process 
//	11/12/2019		AMbuj Tripathi			Bug 88130 - For Varient process unable to create workitem.
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.externalInterfaces;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;


import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.WFXMLUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class WFFormExtClass extends WFExternalInterface {

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	getExternalData
//	Date Written (DD/MM/YYYY)			:	03/10/2013
//	Author								:	Shweta Singhal
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    @Override
    public String getExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
        char defnflag = parser.getCharOf("DefinitionFlag", 'Y', true);
        int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer doctypXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        Object[] result = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
		int procVarId = parser.getIntOf("VariantId", 'Y', true);
		try {
            if(processDefId == 0 || procVarId == 0){
                pstmt=con.prepareStatement("Select ProcessDefId, ProcessVariantId from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId =?");
                WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
                rs = pstmt.executeQuery();
                if(rs.next()){
                    processDefId = rs.getInt("ProcessDefId");
                    procVarId = rs.getInt("ProcessVariantId");
                }
            }
            
            if (processDefId != 0 && procVarId != 0 && activityId != 0 && (defnflag == 'Y' || isCacheExpired(con, parser))) {
            //if (processDefId != 0 && procVarId != 0 && (defnflag == 'Y' || isCacheExpired(con, parser))) {
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                    }
                    doctypXml.append("<FormExt>\n");
                    pstmt=con.prepareStatement("Select ActivityId, Columns, Width1, Width2, Width3 from WFVariantFormTable a " + WFSUtil.getTableLockHintStr(dbType) 
                            + " left outer join ACTIVITYINTERFACEASSOCTABLE b " + WFSUtil.getTableLockHintStr(dbType) + " on a.processdefid = b.ProcessDefId and "
                            + "a.processvariantid = b.processvariantid and a.formextid = b.InterfaceElementId "
                            + "where a.ProcessVariantId = ? and interfacetype = ? and activityid = ?");
					pstmt.setInt(1,procVarId);
                    WFSUtil.DB_SetString(2, "F", pstmt, dbType);
                    pstmt.setInt(3, activityId);
                    pstmt.execute();
					rs=pstmt.getResultSet();
                    if(rs.next()){ 
						HashMap<String,String> layoutMap=new HashMap<String,String>();
						Document doc = WFXMLUtil.createDocument();
						Element root = WFXMLUtil.createRootElement(doc, "Layout");
						do{
                            layoutMap.put("activityId",String.valueOf(activityId));
                            layoutMap.put("columns",String.valueOf(rs.getInt("Columns")));
                            layoutMap.put("width1",String.valueOf(rs.getInt("Width1")));
                            layoutMap.put("width2",String.valueOf(rs.getInt("Width2")));
                            layoutMap.put("width3",String.valueOf(rs.getInt("Width3")));

                            String eleName = "FormLayout";
                            Element formEle = WFXMLUtil.createElement(root, doc, eleName);
                            WFXMLUtil.createAttriElement(layoutMap, formEle);
                            layoutMap=new HashMap<String,String>();
                        }while(rs.next());
						String formXMLPart =  WFXMLUtil.getXmlStringforDOMDocument(doc);
						doctypXml.append(formXMLPart);
                        //System.out.println("docTYeXML after layout>>"+doctypXml.toString());
					}
                    if(	rs!=null){
						rs.close();
						rs=null;
					}                    
                    pstmt=con.prepareStatement("select a.MappedObjectName FieldName, b.methodname Method, b.picklistinfo PickListInfo, b.controltype Controltype from WFVariantFieldInfoTable b " + WFSUtil.getTableLockHintStr(dbType) + " left outer join WFUDTVarMappingTable a " + WFSUtil.getTableLockHintStr(dbType)
                            + " on a.ProcessDefId = b.ProcessDefId and a.ProcessVariantId = b.ProcessVariantId and a.VariableId = b.VariableId and a.VarFieldId = b.VarFieldId "
                            + "where a.ProcessVariantId = ?");
					pstmt.setInt(1,procVarId);
					pstmt.execute();
					rs=pstmt.getResultSet();
					if(rs.next()){ 
						HashMap<String,String> fieldsInfoMap=new HashMap<String,String>();

						Document doc = WFXMLUtil.createDocument();
						Element root = WFXMLUtil.createRootElement(doc, "Fields");
						do{
							String fieldName=rs.getString("FieldName");
							if(!(fieldName.equalsIgnoreCase("ProcessInstanceId")||fieldName.equalsIgnoreCase("WorkItemId"))){
								fieldsInfoMap.put("name",fieldName);
                                fieldsInfoMap.put("methodName",rs.getString("Method"));
                                fieldsInfoMap.put("pickListInfo",rs.getString("PickListInfo"));
                                fieldsInfoMap.put("controlType",String.valueOf(rs.getInt("Controltype")));
                                
                                String eleName = "Field";
								Element fieldEle = WFXMLUtil.createElement(root, doc, eleName);
								WFXMLUtil.createAttriElement(fieldsInfoMap, fieldEle);
								fieldsInfoMap=new HashMap<String,String>();
							}
						}
						while(rs.next());
						String fieldXMLPart =  WFXMLUtil.getXmlStringforDOMDocument(doc);
						doctypXml.append(fieldXMLPart);
                       // System.out.println("after fields>>"+doctypXml.toString());
					}
                    if(	rs!=null){
						rs.close();
						rs=null;
					} 
                    pstmt=con.prepareStatement("Select ActivityId, VariableId,VarFieldId, enable,editable,visible, mandatory mandatory "
                            + "from WFVariantFieldAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessVariantId=? and activityid =?");
					pstmt.setInt(1,procVarId);
                    pstmt.setInt(2,activityId);
					pstmt.execute();
					rs=pstmt.getResultSet();
					if(rs.next()){
						HashMap<String,String> fieldAssocInfoMap=new HashMap<String,String>();
                        Document doc = WFXMLUtil.createDocument();
						Element root = WFXMLUtil.createRootElement(doc, "FieldAssociation");
                        int previousActivityId=0;
						Element actElement = null;
                        PreparedStatement pstmt1= null;
						do{
							int actId=rs.getInt("ActivityId");
                            int variableId = rs.getInt("VariableId");
                            int varFieldId = rs.getInt("VarFieldId");
                            if((actId!=previousActivityId)||(previousActivityId==0)){
								fieldAssocInfoMap.put("id",String.valueOf(actId));
								String eleName = "Activity";
								actElement = WFXMLUtil.createElement(root, doc, eleName);
								WFXMLUtil.createAttriElement(fieldAssocInfoMap, actElement);
								fieldAssocInfoMap=new HashMap<String,String>();
							}
                            
                            fieldAssocInfoMap.put("enable",rs.getString("enable"));
                            fieldAssocInfoMap.put("editable",rs.getString("editable"));
                            fieldAssocInfoMap.put("visible",rs.getString("visible"));
                            fieldAssocInfoMap.put("mandatory",rs.getString("mandatory"));
                            
                            if(varFieldId >0){
                                pstmt1=con.prepareStatement("Select MappedObjectName as FieldName from WFUDTVarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessVariantId = ? and VariableId = ? and VarFieldId = ? and MappedObjectType =? ");
                                pstmt1.setInt(1,procVarId);
                                pstmt1.setInt(2,variableId);
                                pstmt1.setInt(3,varFieldId);
                                WFSUtil.DB_SetString(4, "C", pstmt1, dbType);
                                fieldAssocInfoMap.put("varType","I");
                            }else{
                                pstmt1=con.prepareStatement("Select UserDefinedName as FieldName from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and VariableId = ? and ProcessVariantId = 0");
                                pstmt1.setInt(1,processDefId);
                                pstmt1.setInt(2,variableId);
                                fieldAssocInfoMap.put("varType","U");
                            }
                            rs1 = pstmt1.executeQuery();
                            String fieldName = null;
                            if(rs1.next())
                                fieldName = rs1.getString("FieldName");
                            if(rs1 != null){
                                rs1.close();
                                rs1 = null;
                            }
							Element fieldElement = WFXMLUtil.createElement(actElement , doc, fieldName);
							WFXMLUtil.createAttriElement(fieldAssocInfoMap,fieldElement);
							previousActivityId=actId;
							fieldAssocInfoMap=new HashMap<String,String>();
						}
						while(rs.next());
                        String fieldAssocXMLPart =  WFXMLUtil.getXmlStringforDOMDocument(doc);
                        doctypXml.append(fieldAssocXMLPart);
                        //System.out.println("after fieldassoc>>"+doctypXml.toString());
					}
                    //Creating Field Association
					if(rs!=null){
						rs.close();
						rs=null;
					}
                    
                    pstmt=con.prepareStatement("SELECT VariableId, VarFieldId,LanguageType,CodeSnippet,FieldListener,ObjectForListener, FunctionName FROM WFVariantFormListenerTable  " + WFSUtil.getTableLockHintStr(dbType) + " where processvariantid=? and activityid in (0, "+activityId+")");
					pstmt.setInt(1,procVarId);
					pstmt.execute();
					rs=pstmt.getResultSet();
					if(rs.next()){
						HashMap<String,String> listenerAssocInfoMap=new HashMap<String,String>();
						Document doc = WFXMLUtil.createDocument();
                        Element root = WFXMLUtil.createRootElement(doc, "Listener");
						Element actElement = null;
                        int varFieldId = 0;
                        int varId = 0;
                        do{
                            String object = null;
							listenerAssocInfoMap.put("id",String.valueOf(activityId));
							listenerAssocInfoMap.put("functionName",rs.getString("FunctionName"));
                            listenerAssocInfoMap.put("language",rs.getString("LanguageType"));
							listenerAssocInfoMap.put("codeSnippet",rs.getString("CodeSnippet"));
							listenerAssocInfoMap.put("fieldlistener",String.valueOf(rs.getInt("FieldListener")));
							object = rs.getString("ObjectForListener");
							listenerAssocInfoMap.put("object",object);
							if("C".equalsIgnoreCase(object)){
								varId = rs.getInt("VariableId");
								varFieldId = rs.getInt("VarFieldId");
                                if(varId>0){
                                    if(varFieldId >0){
                                        pstmt = con.prepareStatement("select b.MappedObjectName FieldName, 'WFUDTVarMappingTable' tablename from WFVariantFormListenerTable a " + WFSUtil.getTableLockHintStr(dbType)   + " left outer join WFUDTVarMappingTable b " + WFSUtil.getTableLockHintStr(dbType) + " on a.ProcessVariantId = b.ProcessVariantId and a.VariableId = b.VariableId "
                                                + "and a.VarFieldId = b.VarFieldId where a.ProcessVariantId = ? and a.VariableId = ? and a.VarFieldId = ?");
                                        pstmt.setInt(1,procVarId);
                                        pstmt.setInt(2,varId);
                                        pstmt.setInt(3,varFieldId);
                                    }else{
                                        pstmt = con.prepareStatement("select distinct b.UserDefinedName FieldName, 'VarMappingTable' tablename from WFVariantFormListenerTable a  " + WFSUtil.getTableLockHintStr(dbType) + " left outer join "
                                                + " VARMAPPINGTABLE b " + WFSUtil.getTableLockHintStr(dbType) + " on a.ProcessDefId= b.ProcessDefId and a.VariableId = b.VariableId "
                                                + "where a.ProcessDefId = ? and a.VariableId = ? ");
                                        pstmt.setInt(1,processDefId);
                                        pstmt.setInt(2,varId);
                                    }

                                    rs1 = pstmt.executeQuery();
                                    if(rs1.next()){
                                        listenerAssocInfoMap.put("name",rs1.getString("FieldName"));
                                        if("VarMappingTable".equalsIgnoreCase(rs1.getString("tablename")))
                                            listenerAssocInfoMap.put("varType","U");// User defined Queue Variable
                                        else
                                            listenerAssocInfoMap.put("varType","I");//Variant specific variable
                                    }
                                    if(rs1 != null){
                                        rs1.close();
                                        rs1 = null;
                                    }
                                }
							}
							String eleName = "Activity";
							actElement = WFXMLUtil.createElement(root, doc, eleName);
							WFXMLUtil.createAttriElement(listenerAssocInfoMap, actElement);
							listenerAssocInfoMap=new HashMap<String,String>();
						}
						while(rs.next());
						String assocXMLPart =  WFXMLUtil.getXmlStringforDOMDocument(doc);
						doctypXml.append(assocXMLPart);
                        //System.out.println("after listener>>"+doctypXml.toString());
					}
                    
					if(rs!=null){
						rs.close();
						rs=null;
					}
                    doctypXml.append("</FormExt>\n");
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
                if (!con.getAutoCommit()) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException sqle) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (rs1 != null) {
                    rs1.close();
                    rs1 = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            if (mainCode != 0) {
                WFSUtil.printOut(engine,gen.writeError("WMGetForm", mainCode, subCode, errType,
                WFSErrorMsg.getMessage(mainCode), descr));
            }
        }
        return doctypXml.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 						:	setExternalData
//	Date Written (DD/MM/YYYY)			:	16/05/2002
//	Author								:	Prashant
//	Input Parameters					:	Connection , XMLParser , XMLGenerator
//	Output Parameters					:   none
//	Return Values						:	String
//	Description							:
//----------------------------------------------------------------------------------------------------
    @Override
    public String setExternalData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException {

        String engine = parser.getValueOf("EngineName", "", false);
        int processDefId = parser.getIntOf("ProcessDefinitionID", 0, true);
        int activityId = parser.getIntOf("ActivityID", 0, true);
        String processInst = parser.getValueOf("ProcessInstanceID");
        int workItem = parser.getIntOf("WorkItemID", 0, true);
		int procVarId = parser.getIntOf("VariantId", 'Y', true);
		int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer setXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        ResultSet rs=null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;

        try {
            if(activityId != 0){
                pstmt = con.prepareStatement(" Select 1 from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and ActivityId = ? ");
                pstmt.setInt(1, processDefId);
                pstmt.setInt(2, activityId);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    pstmt.close();
//                    if (processDefId != 0 && activityId != 0) {
//                            
//                    }
                }
            }
                pstmt.close();
                setXml = new StringBuffer(100);
                setXml.append("<WFSetForm_Output>\n");
                setXml.append("<Exception>\n<SubCode>0</SubCode>\n</Exception>\n");
                setXml.append("</WFSetForm_Output>");
            //}
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
                 if (rs != null) {
                     rs.close();
                     rs = null;
                 }
             } catch (Exception e) {
             	WFSUtil.printErr(engine,"", e);
             }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            	WFSUtil.printErr(engine,"", e);
            }
            if (mainCode != 0) {
                setXml = new StringBuffer(100);
                setXml.append("<WFSetForm_Output>\n");
                setXml.append("<Exception>\n<SubCode>" + subCode + "</SubCode>\n<Description>" + descr + "</Description>\n</Exception>\n");
                setXml.append("</WFSetForm_Output>\n");
            }
        }
        return setXml.toString();
    }

} // class WFFormExtClass
