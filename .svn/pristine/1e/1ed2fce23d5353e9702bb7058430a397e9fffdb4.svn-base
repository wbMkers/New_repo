//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					  : Application Products
//	Product / Project		  : WorkFlow
//	Module					  : Transaction Server
//	File Name				  : WFVariableCacheHistory.java
//	Author					  : Mohnish Chopra
//	Date written (DD/MM/YYYY) : 02/07/2013
//	Description			  	  : For BUG 40367- Maintain variable cache for Workitems present in QueueHistoryTable
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
//----------------------------------------------------------------------------------------------------
//
//26/12/2018    Ravi Ranjan Kumar  Bug 82091 - Support of view , fetching data from view for complex variable if view is defined otherwise data will fetch from table
//15/05/2019    Shubham Singla     Bug 84643 - WFVariableCacheHistory call not appending insertion order id in select Query because of which WFGetWorkitemDataExt call is returning distorted data.
//---------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFVariabledef;
import com.newgen.omni.jts.dataObject.WFFieldInfo;
import com.newgen.omni.jts.dataObject.WFRelationInfo;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.*;

public class WFVariableCacheHistory extends cachedObject {

    String key;
    public String xml;
    LinkedHashMap qryRelationMap = null;
    LinkedHashMap qryMemberMap = null;
    LinkedHashMap memberMap = null;
    StringBuffer quebuffer = new StringBuffer(500).append("Select ");
    StringBuffer extbuffer = new StringBuffer(300).append("Select ");
    StringBuffer arraybuffer = new StringBuffer(500).append("Select ");
    StringBuffer keybuffer = new StringBuffer();
    StringBuffer cmplxquebuffer = new StringBuffer("Select ");
    StringBuffer cmplxextbuffer = new StringBuffer("Select ");
    LinkedHashMap cmplxQry = new LinkedHashMap();
    LinkedHashMap arrayQry = new LinkedHashMap();
    private LinkedHashMap FragmentOperationVarMap = new LinkedHashMap(500);//WFS_8.0_084
    private LinkedHashMap FragmentConditionVarMap = new LinkedHashMap(500);//WFS_8.0_084
    String tablename = "";

    protected void setEngineName(String engineName) {
        this.engineName = engineName;
    }

    protected void setProcessDefId(int processDefId) {
        this.processDefId = processDefId;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	create
//	Date Written (DD/MM/YYYY)	:	24/09/2002
//	Author						:	Shweta Tyagi
//	Input Parameters			:	Object key
//	Output Parameters			:   none
//	Return Values				:	Object
//	Description					:   creates WFVariableDef object(code for queue variables and external 
//									variables inherited from prev version)
//----------------------------------------------------------------------------------------------------
      
    protected Object create(Connection con, String key) {

        int dbType = ServerProperty.getReference().getDBType(engineName);
		int activityID = 0;
		//int processVariantId = 0;
		char char21 = 21;
		String string21 = "" + char21;
		char char25 = 25;
		String string25 = "" + char25;
		if(key.indexOf(string21)>0){
			activityID = Integer.parseInt(key.substring(0,key.indexOf(string21)));
			//processVariantId = Integer.parseInt(key.substring(key.indexOf("#")+1));
		}
        else{
			activityID = Integer.parseInt(key);
		}
        PreparedStatement pstmt = null;
        PreparedStatement pstmtext = null;//WFS_8.0_084
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rsext = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        ResultSet rs2 = null;
        ResultSet rs3 = null;//WFS_8.0_084
        WFVariabledef cacheObj = new WFVariabledef();
        LinkedHashMap attribMap = new LinkedHashMap(50);
        LinkedHashMap fieldInfoMap = null;
        LinkedHashMap relationMap = null;
        LinkedHashMap arrayMap = null;
        String tempStr = "";
        int tempVariableId = 0;
        int tempWfType = 0;
        String tempLength = "";
        String tempScope = "";
        int tempPrecison = 0;
        String tempDefault = null;
        int tempParentVarFieldId = 0;
        int tempVarFieldId = 0;
        int tempTypeId = 0;
        int tempRelationId = 0;
        int tempTypeFieldId = 0;
        int tempExtObjId = 0;
        String tempMappedColumn = null;
        String tempMappedTable = null;
        String rightsInfo = "";
        WFFieldInfo wfFieldInfo = null;
        char tempFautoGen = '\0';
        char tempRautoGen = '\0';
        char tempUnbounded = '\0';
        String tempMappedView="";
        String tempIsView="N";

        try {
			//WFS_8.0_084
            pstmtext = con.prepareStatement("select variableid_1 ,type1,variableid_2 ,type2 from wfextinterfaceconditiontable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid=? ");
            pstmtext.setInt(1, processDefId);
            pstmtext.execute();
            rsext = pstmtext.getResultSet();
            int iVariableID1=0;
            String strtype1="";
            int iVariableID2=0;
            String strtype2="";
            String strInterfaceVariableID="";
            while(rsext!=null && rsext.next())
            {
                iVariableID1=rsext.getInt(1);
                strtype1=rsext.getString(2);
                iVariableID2=rsext.getInt(3);
                strtype2=rsext.getString(4);
                if(strtype1.equalsIgnoreCase("I") || strtype1.equalsIgnoreCase("U"))
                {
                    strInterfaceVariableID+=iVariableID1+",";
                    FragmentConditionVarMap.put(iVariableID1, strtype1);
                }
                if(strtype2.equalsIgnoreCase("I") || strtype2.equalsIgnoreCase("U"))
                {
                    strInterfaceVariableID+=iVariableID2+",";
                    FragmentConditionVarMap.put(iVariableID2, strtype2);
                }
            }
            //WFSUtil.printOut("strInterfaceVariableID-->"+strInterfaceVariableID);
            //WFSUtil.printOut("FragmentConditionVarMap-->"+FragmentConditionVarMap);
            if(!strInterfaceVariableID.equalsIgnoreCase(""))
                strInterfaceVariableID=strInterfaceVariableID.substring(0, strInterfaceVariableID.lastIndexOf(","));
            
            //WFSUtil.printOut("strInterfaceVariableID2-->"+strInterfaceVariableID);
            if(!strInterfaceVariableID.equalsIgnoreCase(""))
            {
                pstmtext = con.prepareStatement("select variableid from activityassociationtable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid=? and variableid in ("+strInterfaceVariableID+")");
                pstmtext.setInt(1, processDefId);
                pstmtext.execute();
                rsext = pstmtext.getResultSet();
                String strtempvariableid="";
                while(rsext!=null && rsext.next())
                {
                    strtempvariableid=String.valueOf(rsext.getInt(1));
                    if(FragmentConditionVarMap.containsKey(strtempvariableid))
                        FragmentConditionVarMap.remove(strtempvariableid);
                }
            }
            //WFSUtil.printOut("FragmentConditionVarMap2-->"+FragmentConditionVarMap);

            //pstmtext = con.prepareStatement("select RuleId,InterfaceElementId from wfextinterfaceoperationtable where processdefid=? and InterfaceType='I'");
            pstmtext = con.prepareStatement("select wfextinterfaceoperationtable.RuleId,wfextinterfaceoperationtable.InterfaceElementId,varmappingtable.userdefinedname from wfextinterfaceoperationtable " + WFSUtil.getTableLockHintStr(dbType) + ", varmappingtable " + WFSUtil.getTableLockHintStr(dbType) + " where varmappingtable.processdefid=wfextinterfaceoperationtable.processdefid and varmappingtable.variableid=wfextinterfaceoperationtable.InterfaceElementId and varmappingtable.processdefid=? and InterfaceType="+WFSUtil.TO_STRING("I", true, dbType));
            pstmtext.setInt(1, processDefId);
            pstmtext.execute();
            rsext = pstmtext.getResultSet();
            int iRuleID=0;
            int InterfaceElementId=0;
            String strInterfaceElementId="";
            String cmplxname="";
            while(rsext!=null && rsext.next())
            {
                iRuleID=rsext.getInt(1);
                InterfaceElementId=rsext.getInt(2);
                cmplxname=rsext.getString(3);
                WFSUtil.printOut(engineName,"strQuery0000-->"+cmplxname);
                FragmentOperationVarMap.put(iRuleID, cmplxname);
                strInterfaceElementId+=InterfaceElementId+",";
            }
            if(!strInterfaceElementId.equalsIgnoreCase(""))
                strInterfaceElementId=strInterfaceElementId.substring(0, strInterfaceElementId.lastIndexOf(","));
            String strQuery="";
            if (activityID != 0) {

                /** VarmappingTable contains variables defined in the process. 
                 *  ActivityassociationTable contains rights information on the variable.
                 *  If for a workstep, theres no rights on a variable then there will be no row in ActivityassociationTable.
                 **/
                strQuery="Select VarMappingTable.VariableId,UserDefinedName as AttributeName,VariableType as Type,"
                    + "VariableLength,SystemDefinedName,VarMappingTable.ExtObjID,Attribute,VariableScope,"
                    + "VarMappingTable.VarPrecision , VarMappingTable.unbounded from "
                    + "VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + ",ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) + " where VarMappingTable.ProcessDefID=? and ActivityID=?  and "
                    + WFSUtil.DB_LEN("Attribute", dbType) + "> 0 and DefinitionType In (" + WFSUtil.TO_STRING("I", true, dbType) + "," + WFSUtil.TO_STRING("Q", true, dbType) + " ) and "
                    + "VarMappingTable.ProcessDefID=ActivityAssociationTable.ProcessDefID ";
//                if(!strInterfaceElementId.equalsIgnoreCase(""))
//                strQuery+=" and VarMappingTable.variableid in("+strInterfaceElementId+") ";
                strQuery+=" and UserDefinedName=fieldName and VarMappingTable.VariableId = ActivityAssociationTable.VariableId"
                    + "  UNION Select VariableId,UserDefinedName,VariableType,VariableLength,"
                    + "SystemDefinedName,ExtObjID,VariableScope,VariableScope,VarPrecision,Unbounded from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where "
                    + "SystemDefinedName IN (" + WFSUtil.TO_STRING("VAR_REC_1", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_2", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_3", true, dbType) +
                    "," + WFSUtil.TO_STRING("VAR_REC_4", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_5", true, dbType) + " ) "
                    + "and VarMappingTable.ProcessDefID= ?";
                if(!strInterfaceVariableID.equalsIgnoreCase(""))
                strQuery+= "  UNION Select VariableId,UserDefinedName,VariableType,VariableLength,"+ "SystemDefinedName,ExtObjID,VariableScope,VariableScope,VarPrecision,Unbounded from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + 
                        " where variableid in ("+strInterfaceVariableID+") and VarMappingTable.ProcessDefID= ?";
                pstmt = con.prepareStatement(strQuery);
                pstmt.setInt(1, processDefId);
                pstmt.setInt(2, activityID);
                pstmt.setInt(3, processDefId);
                if(!strInterfaceVariableID.equalsIgnoreCase(""))
                pstmt.setInt(4, processDefId);
                //WFSUtil.printOut("strQuery..1-->"+strQuery);

            } else {
                strQuery="Select VarMappingTable.VariableId, UserDefinedName as AttributeName,VariableType as Type,"
                    + " VariableLength,SystemDefinedName,VarMappingTable.ExtObjID,'O',VariableScope,VarMappingTable.VarPrecision , VarMappingTable.Unbounded from "
                    + "VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where VarMappingTable.ProcessDefID=? and " + WFSUtil.DB_LEN("UserDefinedName", dbType) + "> 0 and "
                    + "(VariableScope in (" + WFSUtil.TO_STRING("I", true, dbType) + "," + WFSUtil.TO_STRING("U", true, dbType) + " ) OR SystemDefinedName IN (" +
                    WFSUtil.TO_STRING("VAR_REC_1", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_2", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_3", true, dbType) + "," +
                    WFSUtil.TO_STRING("VAR_REC_4", true, dbType) + "," + WFSUtil.TO_STRING("VAR_REC_5", true, dbType) + " ))";
                pstmt = con.prepareStatement(strQuery);

                pstmt.setInt(1, processDefId);
            }

            pstmt.execute();
            rs = pstmt.getResultSet();

            int qCount = 0;
            int iCount = 0;
            int cCount = 0;
            int aCount = 0;

            ArrayList queattribs = new ArrayList(50);
            ArrayList extattribs = new ArrayList(20);
            ArrayList cmplxattribs = new ArrayList(50); 
            ArrayList arrayattribs = new ArrayList(50); 

            String[] attrib = new String[10];

            int extObj = 0;
            char scope = '\0';
            int m_extObj = 0;

            while (rs != null && rs.next()) {	//Bugzilla Id 5104
                attrib = new String[10];
                attrib[0] = rs.getString(1); //variableId
                tempVariableId = Integer.parseInt(attrib[0]); 
                attrib[1] = rs.getString(2); //userdefinedname
                attrib[2] = rs.getString(3); //wftype
                tempWfType = Integer.parseInt(attrib[2]);
                tempLength = rs.getString(4); //variable length attrib[3]
                attrib[4] = rs.getString(5); //systemdefinedname
                attrib[5] = rs.getString(6); //extObjId
                if (rs.wasNull()) {
                    attrib[5] = "0";
                }
                attrib[6] = rs.getString(7).trim(); //attribute
                tempScope = rs.getString(8).trim(); //variable scope attrib[7]
                attrib[8] = rs.getString(9); //precison
                try {
					tempPrecison = Integer.parseInt(attrib[8]); 
				}
				catch (NumberFormatException nfe) {
					tempPrecison = 0;
					attrib[8] = "0";
				}
                attrib[9] = rs.getString(10); 
                tempUnbounded = attrib[9].trim().charAt(0);
                if (! (tempScope.equals("I"))) {
                    if (tempLength == null)
                        attrib[3] = "255";
                    else
                        attrib[3] = tempLength;
                } else {
                    if (tempLength == null)
                        attrib[3] = "1024";
                    else
                        attrib[3] = tempLength;
                }
                if (attrib[6].equals("R") || attrib[6].equals("S")) {
                    // SrNo-1, Scope value for read rights was initialized.. Bug rectified by PRD..
                    scope = '\0';
                    attrib[6] = "1";
                } else if (attrib[6].equals("M")) {
                    attrib[6] = "2";
                    scope = 'Q';
                } else if (attrib[6].equalsIgnoreCase("O")) {
                    attrib[6] = "3";
                    scope = 'Q';
                } else {
                    attrib[6] = "4";
                    scope = 'Q';
                }

                attrib[7] = tempScope;

                if (attrib[7].equalsIgnoreCase("M") || attrib[7].equalsIgnoreCase("C")) {
                    attrib[7] = "3" + attrib[6] + attrib[2];
                } else if (attrib[7].equals("I")) {
                    attrib[7] = "2" + attrib[6] + attrib[2];
                } else {
                    attrib[7] = "1" + attrib[6] + attrib[2];
                }
                //condition to check wftype if it is not COMPLEX 
                rightsInfo = attrib[7].substring(0, 2);
				if (fieldInfoMap==null) {
					fieldInfoMap = new LinkedHashMap();
				}
				if (tempWfType != WFSConstant.WF_COMPLEX) {
                    WFFieldInfo fieldInfo = null;
                    /* Primitive type, not an array. */
                    if (attrib[5].equals("0")) {
                        quebuffer.append(attrib[4]);
                        quebuffer.append(" ,");
                        queattribs.add(attrib);
                        qCount++;
                        m_extObj = 0;
                        fieldInfo = new WFFieldInfo(Integer.parseInt(attrib[0]), attrib[1], tempWfType, m_extObj, scope, Integer.parseInt(attrib[3]), tempPrecison, tempUnbounded, rightsInfo);
						fieldInfo.setMappedColumn(attrib[4]);
						//SrNo-4
						fieldInfoMap.put(fieldInfo.getVariableId() + string21 + fieldInfo.getVarFieldId(),fieldInfo);
                    } else if (attrib[9].equalsIgnoreCase("Y")) {
                        /* Primitive array. */
                        pstmt1 = con.prepareStatement("select varfieldid, mappedobjectname, relationid,MappedViewName,IsView from "
                                                      + "wfudtvarmappingtable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and variableid = ? ");
                        pstmt1.setInt(1, processDefId);
                        pstmt1.setInt(2, tempVariableId);
                        pstmt1.execute();
                        rs1 = pstmt1.getResultSet();
                        if (rs1 != null && rs1.next()) {
                            tempVarFieldId = rs1.getInt(1);
                            tempMappedColumn = rs1.getString(2);
                            tempRelationId = rs1.getInt(3);
                            tempMappedView=rs1.getString(4);
                            tempIsView=rs1.getString(5);
                        }
                        rs1.close();
                        rs1 = null;
                        pstmt1.close();
                        pstmt1 = null;
                        try {
                            extObj = Integer.parseInt(attrib[5]);
                            tempMappedTable = WFSExtDB.getTableName(engineName, processDefId, extObj);
                            //if(tempMappedTable.equalsIgnoreCase("QueueDataTable")){
                            if(tempMappedTable.equalsIgnoreCase("WfInstrumentTable")){
                            	tempMappedTable="QueueHistoryTable";
                            }
                            WFSUtil.printOut(engineName,"External TableName-->"+tempMappedTable);
                        } catch (NumberFormatException ex) {} catch (JTSException ex) {}

                        relationMap = new LinkedHashMap();
                        pstmt2 = con.prepareStatement("select OrderId, ParentObject, ChildObject, foreignkey, FautoGen, refkey, RautoGen "
                                                      + " from WFVarRelationTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? and RelationId = ? ");

                        pstmt2.setInt(1, processDefId);
                        pstmt2.setInt(2, tempRelationId);
                        pstmt2.execute();
                        rs2 = pstmt2.getResultSet();
                        while (rs2 != null && rs2.next()) {
                                tempFautoGen = (rs2.getString(5).trim()).charAt(0);
                                tempRautoGen = (rs2.getString(7).trim()).charAt(0);
                                String parentTableName= rs2.getString(2);
                                String childTableName= rs2.getString(3);
                                //if(parentTableName.equalsIgnoreCase("QueueDataTable")){
                                if(parentTableName.equalsIgnoreCase("WFInstrumentTable")){
                                	parentTableName ="QueueHistoryTable";
                                }
                                //if(childTableName.equalsIgnoreCase("QueueDataTable")){
                                if(childTableName.equalsIgnoreCase("WfInstrumentTable")){
                                	childTableName ="QueueHistoryTable";
                                }
                                WFSUtil.printOut(engineName,"Parent-->"+parentTableName);
                                WFSUtil.printOut(engineName,"Child-->"+childTableName);
                                WFRelationInfo relationInfo = new WFRelationInfo(tempRelationId, rs2.getInt(1), parentTableName, childTableName, rs2.getString(4).toUpperCase(), tempFautoGen, rs2.getString(6),
                                                                                 tempRautoGen);
                                relationMap.put( (tempRelationId + string21 + rs2.getInt(1)).toUpperCase(), relationInfo);
                        }
                        rs2.close();
                        rs2 = null;
                        pstmt2.close();
                        pstmt2 = null;
                        if (arrayMap == null) {
                            arrayMap = new LinkedHashMap();
                        }
                        fieldInfo = new WFFieldInfo(tempVariableId,
                                                    tempVarFieldId, 0, attrib[1], 0, tempWfType, extObj, scope, Integer.parseInt(attrib[3]), tempPrecison, null, null, tempMappedTable,
                                                    tempMappedColumn, relationMap, tempUnbounded, rightsInfo,tempMappedView,tempIsView);
                 		//SrNo-4
						fieldInfoMap.put(fieldInfo.getVariableId() + string21 + fieldInfo.getVarFieldId(), fieldInfo);
						arrayattribs.add(attrib);
                        aCount++;

                    } else {
                        try {
                            extObj = Integer.parseInt(attrib[5]);   //WFS_8.0_060   extObj must be 1
                        } catch (NumberFormatException ignored) {}
                        if (tablename.equals("")) {
                            try {
                                tablename = WFSExtDB.getTableName(engineName, processDefId, extObj);
                                //if(tablename.equalsIgnoreCase("QueueDataTable")){
                                if(tablename.equalsIgnoreCase("WFInstrumentTable")){
                                	tablename="QueueHistoryTable";
                                }
							WFSUtil.printOut(engineName,"tablename in VariableCacheHistory-->"+tablename);
                            } catch (JTSException ignored) {}
                        }
                        extbuffer.append(attrib[4]);
                        extbuffer.append(" ,");
                        extattribs.add(attrib);
                        iCount++;
                        m_extObj = extObj;
                        fieldInfo = new WFFieldInfo(Integer.parseInt(attrib[0]), attrib[1], tempWfType, m_extObj, scope, Integer.parseInt(attrib[3]), tempPrecison, tempUnbounded, rightsInfo);
						fieldInfo.setMappedColumn(attrib[4]);
						//SrNo-4
						fieldInfoMap.put(fieldInfo.getVariableId() + string21 + fieldInfo.getVarFieldId(), fieldInfo);
                    }
					if(attrib[6].equals("4")){
						if(!attribMap.containsKey(attrib[1].toUpperCase())){
							attribMap.put(attrib[1].toUpperCase(), fieldInfo);
						}
					}else{
						attribMap.put(attrib[1].toUpperCase(), fieldInfo);
					}
                    //attribMap.put(attrib[1].toUpperCase(), fieldInfo);
                } else {
                    pstmt1 = con.prepareStatement("select varFieldId, TypeId, ParentVarFieldId,"
							+"MappedObjectName, relationId, MappedObjectType, TypeFieldId,extObjId,"
							+" VarPrecision, DefaultValue, MappedViewName, IsView from WFUdtVarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and variableId = ? order by varFieldId");//

                    pstmt1.setInt(1, processDefId);
                    pstmt1.setInt(2, tempVariableId);
                    pstmt1.execute();
                    rs1 = pstmt1.getResultSet();
                    boolean colflag = false;
                    boolean tableflag = false;
                    boolean arrayflag = false;
                    while (rs1 != null && rs1.next()) {
                            tempVarFieldId = rs1.getInt(1);
                            tempTypeId = rs1.getInt(2);
                            tempParentVarFieldId = rs1.getInt(3);
                            String tempMappedObjectType = rs1.getString(6);
                            tempTypeFieldId = rs1.getInt(7);
                            tempExtObjId = rs1.getInt(8);
                            tempPrecison = rs1.getInt(9);
                            tempDefault = rs1.getString(10);
                            tempMappedView=rs1.getString(11);
                            tempIsView=rs1.getString(12);
                            String tempName = null;
                            if (tempParentVarFieldId == 0 && tempTypeFieldId == 0) {
                                tempName = attrib[1];
                            } else {
                                pstmt3 = con.prepareStatement("select FieldName , WFType ,unbounded from WFTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and parentTypeId = ? and typeFieldId = ?");
                                pstmt3.setInt(1, processDefId);
                                pstmt3.setInt(2, tempTypeId);
                                pstmt3.setInt(3, tempTypeFieldId);
                                pstmt3.execute();
                                rs3 = pstmt3.getResultSet();
                                if (rs3 != null && rs3.next()) {
                                    tempName = rs3.getString(1);
                                    tempName=tempName.trim();
                                    tempWfType = rs3.getInt(2);
                                    tempUnbounded = rs3.getString(3).trim().charAt(0);

                                }
                                rs3.close();
                                rs3 = null;
                                pstmt3.close();
                                pstmt3 = null;
                            }

                            if (tempMappedObjectType.equalsIgnoreCase("C")) {
                                tempMappedColumn = rs1.getString(4);
                                
                                colflag = true;
                                tableflag = false;
                                arrayflag = false;
                                if (tempWfType != WFSConstant.WF_COMPLEX && (tempUnbounded == 'Y' || tempUnbounded == 'y')) {
                                    try {
                                        tempMappedTable = WFSExtDB.getTableName(engineName, processDefId, tempExtObjId);
                                        //if(tempMappedTable.equalsIgnoreCase("QueueDataTable")){
                                        if(tempMappedTable.equalsIgnoreCase("WFInstrumentTable")){
                                        	tempMappedTable="QueueHistoryTable";
                                        }
							WFSUtil.printOut(engineName,"tempMappedTable in if-->"+tempMappedTable); 
                                    } catch (JTSException ex) {}
                                    tempRelationId = rs1.getInt(5);
                                    arrayflag = true;
                                    tableflag = false;
                                }

                            } else {
                                colflag = false;
                                tableflag = true;
                                arrayflag = false;
                                tempMappedTable = rs1.getString(4);
                                //if(tempMappedTable.equalsIgnoreCase("QueueDataTable")){
                                if(tempMappedTable.equalsIgnoreCase("WFInstrumentTable")){
                                	tempMappedTable="QueueHistoryTable";
                                }
							WFSUtil.printOut(engineName,"tempMappedTable in else-->"+tempMappedTable);
                                tempRelationId = rs1.getInt(5);
                            }
                            //if(("QueueDataTable").equalsIgnoreCase(tempMappedTable)){
                            if(("WFInstrumentTable").equalsIgnoreCase(tempMappedTable)){
                            	tempMappedTable ="QueueHistoryTable";
                            }
                            if (tableflag || arrayflag) {
                                relationMap = new LinkedHashMap();
                                pstmt2 = con.prepareStatement("Select orderId, ParentObject,ChildObject, foreignKey, fautogen, "
                                                              + "refkey, rautogen from WFVarRelationTable " + WFSUtil.getTableLockHintStr(dbType) + " where processDefId = ? and relationId = ?");
                                pstmt2.setInt(1, processDefId);
                                pstmt2.setInt(2, tempRelationId);
                                pstmt2.execute();
                                rs2 = pstmt2.getResultSet();
                                while (rs2 != null && rs2.next()) {
                                        tempFautoGen = (rs2.getString(5).trim()).charAt(0);
                                        tempRautoGen = (rs2.getString(7).trim()).charAt(0);
                                        String parentTable= rs2.getString(2);
                                        String childTable= rs2.getString(3);
                                        //if(parentTable.equalsIgnoreCase("QueueDataTable")){
                                        if(parentTable.equalsIgnoreCase("WFInstrumentTable")){
                                        	parentTable="QueueHistoryTable";
                                        }
                                        //if(childTable.equalsIgnoreCase("QueueDataTable")){
                                        if(childTable.equalsIgnoreCase("WFInstrumentTable")){
                                        	childTable="QueueHistoryTable";
                                        }
										WFSUtil.printOut(engineName,"parentTable in while-->"+parentTable);
                                        WFSUtil.printOut(engineName,"childTable in while-->"+childTable);
                                        WFRelationInfo relationInfo = new WFRelationInfo(tempRelationId, rs2.getInt(1), parentTable, childTable, rs2.getString(4).toUpperCase(), tempFautoGen,
                                                                                         rs2.getString(6), tempRautoGen);
                                        if (arrayflag) {
                                            WFSUtil.printOut(engineName,"Array Flag true ::relationId-->" + tempRelationId);
                                            WFSUtil.printOut(engineName,"Array Flag true ::orderId-->" + rs2.getInt(1));
                                            WFSUtil.printOut(engineName,"Array Flag true ::parentObject-->" + parentTable);
                                            WFSUtil.printOut(engineName,"Array Flag true ::foreignKey-->" + rs2.getString(4));
                                        }
                                        relationMap.put( (tempRelationId + string21 + rs2.getInt(1)).toUpperCase(), relationInfo);
                                }
                                rs2.close();
								rs2 = null;
                                pstmt2.close();
								pstmt2 = null;
                            }
                            if (colflag && !tableflag) {
                                wfFieldInfo = new WFFieldInfo(tempVariableId, tempVarFieldId, tempParentVarFieldId, tempName, tempTypeId, tempWfType, tempExtObjId, scope, Integer.parseInt(attrib[3]),
                                                              tempPrecison, null, null, null, tempMappedColumn, relationMap, tempUnbounded, rightsInfo,tempMappedView,tempIsView, tempDefault);
                            }
                            if (!colflag && tableflag) {
                                wfFieldInfo = new WFFieldInfo(tempVariableId, tempVarFieldId, tempParentVarFieldId, tempName, tempTypeId, tempWfType, tempExtObjId, scope, Integer.parseInt(attrib[3]),
                                                              tempPrecison, null, null, tempMappedTable, null, relationMap, tempUnbounded, rightsInfo,tempMappedView,tempIsView, tempDefault);
                            }
                            if (arrayflag) {
                                WFSUtil.printOut(engineName,"Arrays Present In process");
                                wfFieldInfo = new WFFieldInfo(tempVariableId, tempVarFieldId, tempParentVarFieldId, tempName, tempTypeId, tempWfType, tempExtObjId, scope, Integer.parseInt(attrib[3]),
                                                              tempPrecison, null, null, tempMappedTable, tempMappedColumn, relationMap, tempUnbounded, rightsInfo,tempMappedView,tempIsView, tempDefault);
                            }

                            //SrNo-4
							fieldInfoMap.put( (tempVariableId + string21 + tempVarFieldId).toUpperCase(), wfFieldInfo);
                            if (tempParentVarFieldId == 0) {
                                attribMap.put(attrib[1].toUpperCase(), wfFieldInfo);
                                cCount++;
                                cmplxattribs.add(attrib);
                            }
                    }
                    rs1.close();
					rs1 = null;
                    pstmt1.close();
					pstmt1 = null;
                    WFFieldInfo.addChildAndParent(fieldInfoMap);

                }
            }
            rs.close();
			rs = null;
            pstmt.close();
			pstmt = null;

			/* Find the mapped field name(if any) corresponding to the column defined in the relation.*/
			WFFieldInfo.setRelationMappedFields(attribMap);
			//SrNo-4
			WFSUtil.printOut(engineName,"all field Info object's map-->"+fieldInfoMap);
			cacheObj.setAllFieldInfoMap(fieldInfoMap);
            if (iCount > 0) {
                extbuffer.append(" null From  ");

                if (tablename != null && !tablename.equals("")) {
                    extbuffer.append(tablename);
                    extbuffer.append(" where ");

                    pstmt = con.prepareStatement(
                        "SELECT Rec1 , Rec2 , Rec3 , Rec4 , Rec5 FROM RecordMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId = ? ");
                    pstmt.setInt(1, processDefId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();

                    if (rs.next()) {
                        for (int k = 1; k <= 5; k++) {
                            tempStr = rs.getString(k);
                            if (!rs.wasNull() && !tempStr.equals("")) {
                                keybuffer.append(tempStr + string21);
                                quebuffer.append(" VAR_REC_" + k + " ,");

                            } else {
                                keybuffer.append(string21);
                            }
                        }
                    }
                    rs.close();
					rs = null;
                    pstmt.close();
					pstmt  = null;
                }

            }

            if (aCount > 0) {
                String qry = null;
                Iterator iter1 = arrayattribs.iterator();
                while (iter1.hasNext()) {
                    String[] arrayattrib = (String[]) iter1.next();
                    WFFieldInfo fieldInfo = (WFFieldInfo) attribMap.get(arrayattrib[1].toUpperCase());
                    qry = this.makeQuery(fieldInfo, fieldInfo.getName(), false);
                    arrayQry.put(fieldInfo.getName().toUpperCase(), qry.toUpperCase());
                }

                WFSUtil.printOut(engineName,"array qry map-->" + arrayQry);
            }
            if (cCount > 0) {
                String tmp_name = "";
                String whereqry = "";
                String frmqry = "";
                LinkedHashMap childarray = null;
                String childQry = "";
                Iterator iter1 = fieldInfoMap.entrySet().iterator();
                childarray = new LinkedHashMap();
                while (iter1.hasNext()) {

                    Map.Entry entries = (Map.Entry) iter1.next();
                    WFFieldInfo fieldInfo = (WFFieldInfo) entries.getValue();

                    if (fieldInfo.getMappedColumn() == null) {
                        StringBuffer tmpname = new StringBuffer();
                        tmpname.append(fieldInfo.getName());
                        WFFieldInfo field_info = fieldInfo;
                        while (field_info.getParentVarFieldId() != 0) {
                            WFFieldInfo parentFieldInfo = (WFFieldInfo) fieldInfoMap.get(field_info.getParentInfo());
                            tmpname.append(string25 + parentFieldInfo.getName());
                            field_info = parentFieldInfo;
                        }
                        tmp_name = tmpname.toString();
                        whereqry = this.makeQuery(fieldInfo, tmp_name, false);
                        cmplxQry.put(tmp_name.toUpperCase(), whereqry);
                    }
                    if (fieldInfo.getMappedColumn() != null && fieldInfo.getMappedTable() != null) {
                        WFSUtil.printOut(engineName,"case of primitive arrays inside complex");
                        StringBuffer tmpname = new StringBuffer();
                        tmpname.append(fieldInfo.getName());
                        WFFieldInfo field_info = fieldInfo;
                        while (field_info.getParentVarFieldId() != 0) {
                            WFFieldInfo parentFieldInfo = (WFFieldInfo) fieldInfoMap.get(field_info.getParentInfo());
                            tmpname.append(string25 + parentFieldInfo.getName());
                            field_info = parentFieldInfo;
                        }
                        tmp_name = tmpname.toString();
						childQry = this.makeQuery(fieldInfo, tmp_name, true);
                        WFSUtil.printOut(engineName,"child array query" + childQry);
                        childarray.put(tmp_name.toUpperCase(), childQry);
                        WFSUtil.printOut(engineName,"childarray" + childarray);
                    }

                }
                iter1 = fieldInfoMap.entrySet().iterator();

                String tempCmplxName = "";
                while (iter1.hasNext()) {
                    Map.Entry entries = (Map.Entry) iter1.next();
                    WFFieldInfo fieldInfo = (WFFieldInfo) entries.getValue();

                    if (fieldInfo.getMappedTable() != null && fieldInfo.getMappedColumn() == null) {
                        StringBuffer tmpname = new StringBuffer();
                        tmpname.append(fieldInfo.getName());
                        WFFieldInfo field_info = fieldInfo;
                        while (field_info.getParentVarFieldId() != 0) {
                            WFFieldInfo parentFieldInfo = (WFFieldInfo) fieldInfoMap.get(field_info.getParentInfo());
                            tmpname.append(string25 + parentFieldInfo.getName());
                            field_info = parentFieldInfo;
                        }
                        tmp_name = tmpname.toString();

                        StringBuffer selectCondition = new StringBuffer("select ");
                        //Bugzilla Bug 5543
						if (!(fieldInfo.isArray())) {
							selectCondition.append(WFSUtil.getFetchPrefixStr(dbType,1));
						}

						String tempSelect = "";
                        String tempTable = "";
                        String tempColumn = "";

                        Iterator iter2 = qryMemberMap.entrySet().iterator();
                        WFSUtil.printOut(engineName,"the member map" + qryMemberMap);
                        while (iter2.hasNext()) {
                            Map.Entry entry = (Map.Entry) iter2.next();
                            tempSelect = (String) entry.getValue();
                            try {
                                tempCmplxName = tempSelect.substring(0, tempSelect.indexOf(":"));
							} catch (Exception ex) {
								WFSUtil.printOut(engineName,"ignorable"+ex);
							}
                            tempSelect = tempSelect.substring(tempSelect.indexOf(":") + 1);
                            tempTable = tempSelect.substring(0, tempSelect.indexOf(string21));
                            tempColumn = tempSelect.substring(tempSelect.indexOf(string21) + 1);
                            tempMappedView=fieldInfo.getMappedViewName();
							WFSUtil.printOut(engineName,"temp select >> "+tempSelect+"temp table >> "+tempTable+"temp column >> "+tempColumn);
                            if (fieldInfo.getMappedTable().equalsIgnoreCase(tempTable) && tmp_name.equalsIgnoreCase(tempCmplxName) &&
                                (selectCondition.toString().toUpperCase()).indexOf(" "+tempColumn.toUpperCase()+",") == -1) {//Bugzilla Bug 7133
                                selectCondition.append(tempColumn + ", ");
								//WFSUtil.printOut("appending  >>" +selectCondition);
		                    }
                        }

                        if (qryRelationMap != null) {
                            iter2 = qryRelationMap.entrySet().iterator();
                            while (iter2.hasNext()) {
                                Map.Entry entry = (Map.Entry) iter2.next();
                                tempSelect = (String) entry.getKey();
                               //Bugzilla Id 5109
								try {
                                    tempCmplxName = tempSelect.substring(tempSelect.indexOf(string25)+1);
								} catch (Exception ex) {
									tempCmplxName = tempSelect;	//ignoring stringOutOfBoundException
								}
                                try {
									tempCmplxName = tempCmplxName.substring(0, tempCmplxName.indexOf(":"));
								}
                                catch (Exception ex){
									WFSUtil.printOut(engineName,"ignoring >> "+ex);
								} //ignoring stringOutOfBoundException
								tempSelect = tempSelect.substring(tempSelect.indexOf(":") + 1);
                                tempTable = tempSelect.substring(0, tempSelect.lastIndexOf(string21));
                                tempColumn = tempSelect.substring(tempSelect.lastIndexOf(string21) + 1);
                                WFSUtil.printOut(engineName,"temp select >> "+tempSelect+"temp table >> "+tempTable+"temp column >> "+tempColumn);
								if (!tempCmplxName.equals("")) {
                                    if (fieldInfo.getMappedTable().equalsIgnoreCase(tempTable) && tmp_name.equalsIgnoreCase(tempCmplxName) &&
                                        (selectCondition.toString().toUpperCase()).indexOf(" "+tempColumn.toUpperCase()+",") == -1) {//Bugzilla Bug 7133
                                        selectCondition.append(tempColumn + ", ");
                                        //WFSUtil.printOut("appending  >>" +selectCondition);

									}
                                }

                            }
                        }
						if (fieldInfo.isArray()) {
                        	selectCondition.append("InsertionOrderId, ");
                        }
                        selectCondition.deleteCharAt(selectCondition.lastIndexOf(","));
                        if(tempMappedView!=null&&tempMappedView!=""){
                        	frmqry = "from " + tempMappedView + WFSUtil.getTableLockHintStr(dbType) ;
                        }
                        else{
                        	frmqry = "from " + fieldInfo.getMappedTable()  + WFSUtil.getTableLockHintStr(dbType) ;
                        }
                        whereqry = (String) cmplxQry.get(tmp_name.toUpperCase());
                        //Bugzilla Bug 5543,5972
						if (!(fieldInfo.isArray())) {

							whereqry = whereqry + WFSUtil.getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND);
						}
						cmplxQry.put(tmp_name.toUpperCase(), (selectCondition.toString() + frmqry + whereqry).toUpperCase());

                    }

                }
                if (childarray != null) {
                    iter1 = childarray.entrySet().iterator();
                    while (iter1.hasNext()) {
                        Map.Entry entries = (Map.Entry) iter1.next();
                        tempCmplxName = (String) entries.getKey();
                        childQry = (String) entries.getValue();

                        try {
                            tmp_name = tempCmplxName.substring(tempCmplxName.indexOf(string25) + 1);
                        } catch (Exception ex) {}

                        Iterator iter2 = cmplxQry.entrySet().iterator();
                        while (iter2.hasNext()) {
                            Map.Entry entry = (Map.Entry) iter2.next();
                            String tmpstr = (String) entry.getKey();
                            //tmpstr = tmpstr.substring(tmpstr.indexOf("@")+1);

                            WFSUtil.printOut(engineName,"Query for child array" + childQry);
                            if (tmpstr.equalsIgnoreCase(tmp_name)) {
                                cmplxQry.put( (String) entry.getKey(), ( (String) entry.getValue() + string21 + childQry).toUpperCase());
                            }
                        }

                    }
                }
                WFSUtil.printOut(engineName,"Cmplex qry map" + cmplxQry);
                memberMap = new LinkedHashMap();
                ListIterator itr = cmplxattribs.listIterator();
                while (itr.hasNext()) {
                    String[] cmplxvar = (String[]) itr.next();
                    WFFieldInfo fieldInfo = (WFFieldInfo) attribMap.get(cmplxvar[1].toUpperCase());
                    memberMap.put((fieldInfo.getName()).toUpperCase(), this.makeMemberMap(fieldInfo));
                }
                WFSUtil.printOut(engineName,"Variable Member Map"+memberMap);
            }
            if (cmplxquebuffer.length() < 8) {

                cmplxquebuffer = null;
            }
            if (cmplxextbuffer.length() < 8) {

                cmplxextbuffer = null;
            } else {
                cmplxextbuffer.append("null from " + tablename +  WFSUtil.getTableLockHintStr(dbType) +  " where ");
            }
            //WFSUtil.printOut(engineName,"queuedatatable query" + cmplxquebuffer);
            WFSUtil.printOut(engineName,"WFInstrumentTable query" + cmplxquebuffer);
            WFSUtil.printOut(engineName,"external table query" + cmplxextbuffer);

            for (int i = 0; i < WFSConstant.prcattribs.length; i++) {
                rightsInfo = WFSConstant.prcattribs[i][1].substring(0, 2);
                attribMap.put(WFSConstant.prcattribs[i][0].toUpperCase(),
                              new WFFieldInfo(Integer.parseInt(WFSConstant.prcattribs[i][3]), WFSConstant.prcattribs[i][0], Integer.parseInt(WFSConstant.prcattribs[i][1].substring(2)), 0,
                                              (WFSConstant.prcattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
                fieldInfoMap.put(WFSConstant.prcattribs[i][3] + string21 + "0",
                        new WFFieldInfo(Integer.parseInt(WFSConstant.prcattribs[i][3]), WFSConstant.prcattribs[i][0], Integer.parseInt(WFSConstant.prcattribs[i][1].substring(2)), 0,
                                              (WFSConstant.prcattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
            }
            for (int i = 0; i < WFSConstant.qdmattribs.length; i++) {
                rightsInfo = WFSConstant.qdmattribs[i][1].substring(0, 2);
                attribMap.put(WFSConstant.qdmattribs[i][0].toUpperCase(),
                              new WFFieldInfo(Integer.parseInt(WFSConstant.qdmattribs[i][3]), WFSConstant.qdmattribs[i][0], Integer.parseInt(WFSConstant.qdmattribs[i][1].substring(2)), 0,
                                              (WFSConstant.qdmattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
                fieldInfoMap.put(WFSConstant.qdmattribs[i][3] + string21 + "0",
                              new WFFieldInfo(Integer.parseInt(WFSConstant.qdmattribs[i][3]), WFSConstant.qdmattribs[i][0], Integer.parseInt(WFSConstant.qdmattribs[i][1].substring(2)), 0,
                                              (WFSConstant.qdmattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
            }
            for (int i = 0; i < WFSConstant.wklattribs.length; i++) {
                rightsInfo = WFSConstant.wklattribs[i][1].substring(0, 2);
                attribMap.put(WFSConstant.wklattribs[i][0].toUpperCase(),
                              new WFFieldInfo(Integer.parseInt(WFSConstant.wklattribs[i][3]), WFSConstant.wklattribs[i][0], Integer.parseInt(WFSConstant.wklattribs[i][1].substring(2)), 0,
                                              (WFSConstant.wklattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
                fieldInfoMap.put(WFSConstant.wklattribs[i][3] + string21 + "0",
                              new WFFieldInfo(Integer.parseInt(WFSConstant.wklattribs[i][3]), WFSConstant.wklattribs[i][0], Integer.parseInt(WFSConstant.wklattribs[i][1].substring(2)), 0,
                                              (WFSConstant.wklattribs[i][2]).trim().charAt(0), 255, 0, 'N', rightsInfo));
            }

            //attribMap.put("PRIORITYLEVEL", new WFFieldInfo(0,"PRIORITYLEVEL",  WFSConstant.WF_INT,0, 'M', 255,0,'\0'));
            //attribMap.put("STATUS", new WFFieldInfo(0,"STATUS", WFSConstant.WF_STR, 0,'Q', 255,0,'\0'));
            //attribMap.put("SAVESTAGE", new WFFieldInfo(0,"SAVESTAGE",WFSConstant.WF_STR, 0,'Q', 255,0,'\0'));

            cacheObj.setAttribMap(attribMap);

            cacheObj.setQueueVars(queattribs);
            cacheObj.setExtVars(extattribs);
            cacheObj.setCmplxVars(cmplxattribs);
            cacheObj.setArrayVars(arrayattribs);

            cacheObj.setQueueString(quebuffer);
            cacheObj.setExtString(extbuffer);
            cacheObj.setCmplxQueString(cmplxquebuffer);
            cacheObj.setCmplxExtString(cmplxextbuffer);
            cacheObj.setKeyBuffer(keybuffer);

            cacheObj.setMemberMap(memberMap);
            WFSUtil.printOut(engineName,"qryRelationMap>>>>>"+ qryRelationMap);
            cacheObj.setQryRelationMap(qryRelationMap);
            cacheObj.setCmplxQry(cmplxQry);
            cacheObj.setArrayQry(arrayQry);
			//WFS_8.0_084
            cacheObj.setFragmentOperationVarMap(FragmentOperationVarMap);
            cacheObj.setFragmentConditionVarMap(FragmentConditionVarMap);

            cacheObj.setExt_tablename(tablename);

        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
        } finally {			//Bugzilla Id 5104
           
            	
            	
            	try {
            		if(rs3!=null) {
    					rs3.close();
    					rs3 = null;
    				}
  			  }
  			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
  			
  			  try {
  				if(pstmt3!=null) {
					pstmt3.close();
					pstmt3 = null;
				}
  			  }
  			  catch(Exception ignored)
  			  {
  				  WFSUtil.printErr(engineName,"", ignored);
  				  }
                
  			try {
  				if(rs2!=null) {
					rs2.close();
					rs2 = null;
				}
			  }
			  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
			
			  try {
				  if(pstmt2!=null) {
						pstmt2.close();
						pstmt2 = null;
					}
			
			  }
			  catch(Exception ignored)
			  {
				  WFSUtil.printErr(engineName,"", ignored);
				  }
			  try {
				  if(rs1!=null) {
						rs1.close();
						rs1 = null;
					}
				  }
				  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
				
				  try {

						if(pstmt1!=null) {
							pstmt1.close();
							pstmt1 = null;
						}
				
				  }
				  catch(Exception ignored)
				  {
					  WFSUtil.printErr(engineName,"", ignored);
					  }
				  
				  try {
					  if(rs!=null) {
							rs.close();
							rs = null;
						}
					  }
					  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
					
					  try {

						  if(pstmt!=null) {
								pstmt.close();
								pstmt = null;
							}
					
					  }
					  catch(Exception ignored)
					  {
						  WFSUtil.printErr(engineName,"", ignored);
						  }
					  try {
						  if(rsext!=null) {
							  rsext.close();
							  rsext = null;
							}
						  }
						  catch(Exception ignored){WFSUtil.printErr(engineName,"", ignored);}
						
						  try {

							  if(pstmtext!=null) {
								  pstmtext.close();
								  pstmtext = null;
								}
						
						  }
						  catch(Exception ignored)
						  {
							  WFSUtil.printErr(engineName,"", ignored);
							  }
				
				
				
				
				
            }
        
        WFSUtil.printOut(engineName,this.toString());
        WFSUtil.printOut(engineName,"Table Name::::::::::"+cacheObj.getExt_tablename());
        return cacheObj;
    }
    
    
//Bugzilla Bug 6919
    /*public String toString() {
        StringBuffer buffer = new StringBuffer(100);
        buffer.append("***** The VariableCache *****");
        buffer.append(System.getProperty("line.separator") + "key - " + key);
        buffer.append(System.getProperty("line.separator") + "xml - " + xml);
        buffer.append(System.getProperty("line.separator") + "qryRelationMap - " + qryRelationMap);
        buffer.append(System.getProperty("line.separator") + "qryMemberMap - " + qryMemberMap);
        buffer.append(System.getProperty("line.separator") + "memberMap - " + memberMap);
        buffer.append(System.getProperty("line.separator") + "quebuffer - " + quebuffer);
        buffer.append(System.getProperty("line.separator") + "extbuffer - " + extbuffer);
        buffer.append(System.getProperty("line.separator") + "arraybuffer - " + arraybuffer);
        buffer.append(System.getProperty("line.separator") + "keybuffer - " + keybuffer);
        buffer.append(System.getProperty("line.separator") + "cmplxquebuffer - " + cmplxquebuffer);
        buffer.append(System.getProperty("line.separator") + "cmplxextbuffer - " + cmplxextbuffer);
        buffer.append(System.getProperty("line.separator") + "cmplxQry - " + cmplxQry);
        buffer.append(System.getProperty("line.separator") + "arrayQry - " + arrayQry);
        buffer.append(System.getProperty("line.separator") + "tablename - " + tablename);
        buffer.append("^^^^^ The VariableCache ^^^^^");
        return buffer.toString();
    }*/

    protected String makeQuery(WFFieldInfo fieldInfo, String tmp_name, boolean arrayInCmplx) {
        StringBuffer whereCondition = new StringBuffer(" where ");
        LinkedHashMap relationMap = fieldInfo.getRelationMap();
		int dbType = ServerProperty.getReference().getDBType(engineName);
		String name = "";
		char char21 = 21;
		String string21 = "" + char21;
		char char25 = 25;
		String string25 = "" + char25;
		if (relationMap == null) {
            WFSUtil.printOut(engineName,"[makeQuery]relationMap null");
        } else {
            Iterator iter2 = relationMap.entrySet().iterator();
            String tempTableName = fieldInfo.getMappedTable().toUpperCase();
            String tempMappedView=fieldInfo.getMappedViewName();

            int i = 0;
			while (iter2.hasNext()) {
                name = tmp_name;
				Map.Entry relationEntries = (Map.Entry) iter2.next();
                String tempParentObject = ( (WFRelationInfo) relationEntries.getValue()).getParentObject().toUpperCase();
                String tempChildObject = ( (WFRelationInfo) relationEntries.getValue()).getChildObject().toUpperCase();
                String tempForeignKey = ( (WFRelationInfo) relationEntries.getValue()).getForeignKey();
                String tempRefKey = ( (WFRelationInfo) relationEntries.getValue()).getRefKey();
                //if (tempParentObject.equalsIgnoreCase("queuedatatable") || tempParentObject.equalsIgnoreCase("queuehistorytable")) {
                if (tempParentObject.equalsIgnoreCase("wfinstrumenttable") || tempParentObject.equalsIgnoreCase("queuehistorytable")) {
                    //WFSUtil.printOut("[line num 416]" + quebuffer.toString());
                    if (qryRelationMap == null) {
                        qryRelationMap = new LinkedHashMap();
                    }
                    if (qryRelationMap.containsKey( (tempParentObject + string21 + tempForeignKey).toUpperCase())) {
                    } else {
                        qryRelationMap.put( (tempParentObject + string21 + tempForeignKey).toUpperCase(), null);
                    }
                    //Bug 5580
					if (cmplxquebuffer.toString().toUpperCase().indexOf(tempForeignKey.toUpperCase()) == -1 && quebuffer.toString().toUpperCase().indexOf(tempForeignKey.toUpperCase()) == -1) {
                        cmplxquebuffer.append(tempForeignKey + ",");
                    }

                } else if (tempParentObject.equalsIgnoreCase(tablename)) {
                    if (qryRelationMap == null) {
                        qryRelationMap = new LinkedHashMap();
                    }
                    if (qryRelationMap.containsKey( (tempParentObject + string21 + tempForeignKey).toUpperCase())) {
                    } else {
                        qryRelationMap.put( (tempParentObject + string21 + tempForeignKey).toUpperCase(), null);
                    }
                    //Bug 5580
					if (cmplxextbuffer.toString().toUpperCase().indexOf(tempForeignKey.toUpperCase()) == -1 && extbuffer.toString().toUpperCase().indexOf(tempForeignKey.toUpperCase()) == -1) {
                        cmplxextbuffer.append(tempForeignKey + ",");
                    }
                } else if (tempParentObject.equalsIgnoreCase(tempTableName)) {
                    if (qryRelationMap == null) {
                        qryRelationMap = new LinkedHashMap();
                    }
                   if (arrayInCmplx) {
                        if (name.indexOf(string25) != -1)
                            name = name.substring(name.indexOf(string25));// 23/10/2008
                    }
					if (qryRelationMap.containsKey( (name + ":" + tempParentObject + string21 + tempForeignKey).toUpperCase())) {
                    } else {

						qryRelationMap.put( (name + ":" + tempParentObject + string21 + tempForeignKey).toUpperCase(), null);


                    }
                } else {
                    if (qryRelationMap == null) {
                        qryRelationMap = new LinkedHashMap();
                    }
                    if (qryRelationMap.containsKey( (name + ":" + tempParentObject + string21 + tempForeignKey).toUpperCase())) {
                    } else {

						if (arrayInCmplx) {
                            if (name.indexOf(string25) != -1)
                                name = name.substring(name.indexOf(string25));// 23/10/2008
                        }

                        qryRelationMap.put( (name + ":" + tempParentObject + string21 + tempForeignKey).toUpperCase(), null);

                    }
                }
                if(tempMappedView!=null&&tempMappedView!=""){
                	tempChildObject=tempMappedView.toUpperCase();
                }

                whereCondition.append(tempChildObject + "." + tempRefKey + "=" + tempParentObject + "." + tempForeignKey + " AND ");
            }
            //cmplxbuffer.deleteCharAt(cmplxbuffer.lastIndexOf(","));
            LinkedHashMap childMap = fieldInfo.getChildInfoMap();
            if (childMap == null) {
                if (fieldInfo.getMappedColumn() != null) {
                    //case of root level primitive arrays && child level primitive arrays
                    whereCondition.append("1=1");
                    String arrayQry = "select " + fieldInfo.getMappedColumn().toUpperCase() + " from " + fieldInfo.getMappedTable() + WFSUtil.getTableLockHintStr(dbType) + whereCondition.toString();
                    return arrayQry;
                }
            } else {
                Iterator iter3 = childMap.entrySet().iterator();
                while (iter3.hasNext()) {
                    Map.Entry childEntries = (Map.Entry) iter3.next();
                    WFFieldInfo childFieldInfo = (WFFieldInfo) childEntries.getValue();

                    String tempMappedColumn = childFieldInfo.getMappedColumn();
                    String tempMappedTable = childFieldInfo.getMappedTable();
                    if (tempMappedColumn != null) {

                        if (qryMemberMap == null) {
                            qryMemberMap = new LinkedHashMap();
                        }

                        if ( (childFieldInfo.getUnbounded() == 'N' || childFieldInfo.getUnbounded() == 'n')) {
                            if (qryMemberMap.containsKey( (childFieldInfo.getVariableId() + string21 + childFieldInfo.getVarFieldId()).toUpperCase())) {
                            //do nothing
                            } else {
                                qryMemberMap.put( (childFieldInfo.getVariableId() + string21 + childFieldInfo.getVarFieldId()).toUpperCase(),
                                                 (name + ":" + tempTableName + string21 + tempMappedColumn).toUpperCase());
                            }
                        } else {
                            if (qryMemberMap.containsKey( (childFieldInfo.getVariableId() + string21 + childFieldInfo.getVarFieldId()).toUpperCase())) {
                            //do nothing
                            } else {
                                qryMemberMap.put( (childFieldInfo.getVariableId() + string21 + childFieldInfo.getVarFieldId()).toUpperCase(),
                                                 (name + ":" + tempMappedTable + string21 + tempMappedColumn).toUpperCase());
                            }

                        }

                    }
                }
            }
        }
        whereCondition.append("1=1");
        return whereCondition.toString();
    }

    protected LinkedHashMap makeMemberMap(WFFieldInfo fieldInfo) {

        LinkedHashMap map = new LinkedHashMap();
        LinkedHashMap childMap = fieldInfo.getChildInfoMap();
		char char21 = 21;
		String string21 = "" + char21;
        if (childMap != null) {
            Iterator itr = childMap.entrySet().iterator();
            while (itr.hasNext()) {
                Map.Entry entry = (Map.Entry) itr.next();
                WFFieldInfo childInfo = (WFFieldInfo) entry.getValue();
                if (childInfo.getWfType() == WFSConstant.WF_COMPLEX) {
                    map.put((childInfo.getName()).toUpperCase(), this.makeMemberMap(childInfo));//SrNo-1

                } else {
                    map.put((childInfo.getName()).toUpperCase(), (String) qryMemberMap.get(childInfo.getVariableId()+string21 +childInfo.getVarFieldId()));//SrNo-1	//SrNo-2

                }
            }
        }

        return map;
    }
}