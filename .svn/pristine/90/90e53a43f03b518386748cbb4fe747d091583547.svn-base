//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFTrigger.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 24/09/2002
//	Description			: class for all cached Trigger Objects.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By	    Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 20/08/2004		Ruhi Hira	    CacheTime related changes
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static hashmap.
// 05/06/2007           Ruhi Hira           WFS_5_161, MultiLingual Support (Inherited from 5.0).
// 18/06/2007           Ruhi Hira           Bugzilla Bug 1192.
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 02/09/2008			Shweta Tyagi	    SrNo-2  Added VariableId and VarFieldId to provide Complex 
//										    Data Type Support
// 09/04/2009           Saurabh Kamal       OFME(PDA) Support
// 01/07/2009           Saurabh Kamal       SrNo-3 Append trigger to todoXml if only view type = 'T'
// 05/07/2012  			Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 14-03-2014			Sajid Khan			Bug 43385 [Random case: Todos not getting fetched for mobile].
// 15-01-2019			Ambuj Tripathi		Merging changes related to CQRN-0000008530 - To-do list values order not changing. from 3.0sp2 to 4.0 sp1
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;

public class WFTodoList extends cachedObject{

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
    protected Object create(Connection con, String key){
		char char21 = 21;
		String string21 = "" + char21;
		char char25 = 25;
		String string25 = "" + char25;
		int dbType = ServerProperty.getReference().getDBType(engineName);
        String parseStr = null;
        StringBuffer toDoXml = new StringBuffer(500);
        java.util.HashMap todoStatMap = new java.util.HashMap();
        StringBuffer todoTrgrMap = new StringBuffer(64);
        StringBuffer todoPLstMap = new StringBuffer(64);
        HashMap localeToDoMap = new HashMap();
		String locale = null;
		String pdaFlag = "N";
		String pdaTableStr = "";
		String pdaFilterStr = "";
                int activityId = 0;
                //Sajid Khan - 13-03-2014 : Key modofied
		int index = key.indexOf(string21);
                int indexprocVar = key.indexOf(string25);
                int procVarId = 0;
                if (index == -1 && indexprocVar > 0) {
                     activityId = Integer.parseInt(key.substring(0, indexprocVar));
                     procVarId = Integer.parseInt(key.substring(indexprocVar+1));
                } else if(index > 0 ){
                    activityId = Integer.parseInt(key.substring(0, index));
                    if(indexprocVar >0){
                        pdaFlag = key.substring(index+1, indexprocVar);
                        procVarId = Integer.parseInt(key.substring(indexprocVar+1));
                    }else
                         pdaFlag = key.substring(index+1);
                    if (pdaFlag.equalsIgnoreCase("Y")) {
                            pdaTableStr = ", WFPDATable B ";
                            pdaFilterStr = " AND A.ProcessDefId = B.ProcessDefId and B.InterfaceType = " + WFSUtil.TO_STRING(WFSConstant.INTERFACE_TYPE_TODO, true, dbType) + " and A.ToDoId = B.InterfaceId and Activityid = " + activityId;
                    }
             }


//		if (index == -1 ){
//			locale = key;
//		} else {
//			locale = key.substring(0, index);
//			//pdaFlag = key.substring(index + 1);
//                        pdaFlag = "N";
//			if (pdaFlag.equalsIgnoreCase("Y")) {
//				pdaTableStr = ", WFPDATable B ";
//				pdaFilterStr = " AND A.ProcessDefId = B.ProcessDefId and B.InterfaceType = " + WFSUtil.TO_STRING(WFSConstant.INTERFACE_TYPE_TODO, true, dbType) + " and A.ToDoId = B.InterfaceId ";
//			}
//		}
        
        String srcXML = "";
        String filterStr = null;
        String localeParam = null;

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        gen = new XMLGenerator();

        /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
        try{
            if(locale != null && locale.trim().length() > 0){
                /** @todo InterfaceId is hardcoded 1 here - Ruhi Hira */
                /* Bugzilla Bug 1192, one ? missing, 19/06/2007 - Ruhi Hira */
                if(locale.indexOf("-") >= 0){
                    filterStr = WFSUtil.TO_STRING("Locale", false, dbType) + " = ? ";
                    localeParam = locale.trim().toUpperCase();
                } else {
                    filterStr = WFSUtil.TO_STRING("Locale", false, dbType) + " like ? ";
                    localeParam = locale.trim().toUpperCase() + "%";
                }
                pstmt = con.prepareStatement(
                    " Select ElementId , Description from InterfaceDescLanguageTable " + WFSUtil.getTableLockHintStr(dbType) 
                    + " where ProcessDefID = ? and InterfaceId = 1 and "
                    + filterStr);
                pstmt.setInt(1, processDefId);
                pstmt.setString(2, localeParam);
                pstmt.execute();
                rs = pstmt.getResultSet();
                while(rs.next()){
                    localeToDoMap.put(String.valueOf(rs.getInt(1)), rs.getString(2));
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
            }
        } catch(SQLException e){
            WFSUtil.printErr(engineName,"", e);
        } finally {
            if(rs != null){
                try{
                    rs.close();
                    rs = null;
                } catch(SQLException ignored){}
            }
            if(pstmt != null){
                try{
                    pstmt.close();
                } catch(SQLException ignored){}
                pstmt = null;
            }
        }

        try{
//----------------------------------------------------------------------------
// Changed By						: Saurabh Kamal
// Reason / Cause (Bug No if Any)	: OFME Support
// Change Description				: Differend query execution on the basis of pdaFlag
// Date                             : 09/04/2009
//----------------------------------------------------------------------------
                pstmt = con.prepareStatement(
                " Select ToDoId , ExtObjID , Mandatory , ViewType , ToDoName , Description , "
                + " AssociatedField , TriggerName, VariableId, VarFieldId from ToDoListDefTable A " + WFSUtil.getTableLockHintStr(dbType) + pdaTableStr 
				+ " where A.ProcessDefID = ? " + pdaFilterStr);
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();

            int todo = 0;
            String viewType = "";
            String trigger = "";
            String trgrtdId = "";
            int toDocount = 0;
            while(rs.next()){
                toDocount++;
                toDoXml.append("<ToDoListDef>\n");
                todo = rs.getInt(1);
                toDoXml.append(gen.writeValueOf("ToDoIndex", String.valueOf(todo)));
                toDoXml.append(gen.writeValueOf("ToDoExternalObjectIndex", rs.getString(2)));
                toDoXml.append(gen.writeValueOf("Mandatory", rs.getString(3)));
                viewType = rs.getString(4);
                toDoXml.append(gen.writeValueOf("ViewType", viewType));
                toDoXml.append(gen.writeValueOf("Name", rs.getString(5)));
                if (localeToDoMap.containsKey(String.valueOf(todo))){
                    toDoXml.append(gen.writeValueOf("Description", localeToDoMap.get(String.valueOf(todo)).toString()));
                } else{
                    toDoXml.append(gen.writeValueOf("Description", rs.getString(6)));
                }
                toDoXml.append(gen.writeValueOf("AssociatedField", rs.getString(7)));
                trigger = rs.getString(8);
				//SrNo-3
				if(viewType.startsWith("T")){
					if(!rs.wasNull()){
						toDoXml.append("ÿ" + trigger.trim() + "ÿ");
						todoTrgrMap.append("," + trigger.trim());
					}
				}
                if(viewType.startsWith("P")){
					toDoXml.append("ü" + todo + "ü");
                    todoPLstMap.append(todo + ", ");
                }
                //SrNo-2
				toDoXml.append(gen.writeValueOf("VariableId", rs.getString(9)));
                toDoXml.append(gen.writeValueOf("VarFieldId", rs.getString(10)));
				toDoXml.append("</ToDoListDef>\n");
            }
            toDoXml.append("</ToDoListDefs>\n");
            srcXML = toDoXml.toString();

            java.util.StringTokenizer st = new java.util.StringTokenizer(todoTrgrMap.toString(), ",");
            while(st.hasMoreTokens()){
                String trgr_name = st.nextToken();
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: for Automatic Cache updation
// Change Description				: Used Singleton class CachedObjectCollection
//----------------------------------------------------------------------------
                String trgr_def = (String) CachedObjectCollection.getReference().getCacheObject(con, engineName, processDefId, WFSConstant.CACHE_CONST_Trigger, trgr_name).getData();
				srcXML = WFSUtil.replace(srcXML, "ÿ" + trgr_name + "ÿ", trgr_def);
            }

            pstmt = con.prepareStatement(
                " Select ToDoId, PickListValue, PickListId , PickListOrderId from ToDoPickListTable " + WFSUtil.getTableLockHintStr(dbType) + " where ToDoId in ("
                + todoPLstMap.toString() + " -1) and ProcessDefId = ? ORDER BY ToDoID, PickListOrderId");
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            int oldtodoId = 0;
            int count = 0;
            toDoXml = new StringBuffer(100);
            while(rs.next()){
                int todoId = rs.getInt(1);
                if(oldtodoId != todoId){
                    if(oldtodoId != 0){
                        toDoXml.insert(0, "<PickLists>");
                        toDoXml.append(gen.writeValueOf("PickListCount", String.valueOf(count)));
                        toDoXml.append("</PickLists>");
						srcXML = WFSUtil.replace(srcXML, "ü" + oldtodoId + "ü", toDoXml.toString());
                    }
                    count = 0;
                    oldtodoId = todoId;
                    toDoXml = new StringBuffer(100);
                }
                count++;
                toDoXml.append("<PickListData>");
                toDoXml.append(gen.writeValueOf("PickList", rs.getString(2)));
                toDoXml.append(gen.writeValueOf("PickListId", String.valueOf(rs.getInt(3))));
                toDoXml.append(gen.writeValueOf("PickListOrderId", String.valueOf(rs.getInt(4))));
                toDoXml.append("</PickListData>");
            }

            if(oldtodoId != 0){
                toDoXml.insert(0, "<PickLists>");
                toDoXml.append(gen.writeValueOf("PickListCount", String.valueOf(count)));
                toDoXml.append("</PickLists>");
				srcXML = WFSUtil.replace(srcXML, "ü" + oldtodoId + "ü", toDoXml.toString());
            }
            // Parse and put in a Vector
            todoStatMap = new HashMap();
            XMLParser parser = new XMLParser();
            parser.setInputXML(srcXML);
            parseStr = parser.getFirstValueOf("ToDoListDef");
            if(!parseStr.equals("")){
                todoStatMap.put(parser.getNextValueOf("ToDoIndex"), parseStr);
                for(int i = 1; i < toDocount; i++){
                    parseStr = parser.getNextValueOf("ToDoListDef");
                    todoStatMap.put(parser.getNextValueOf("ToDoIndex"), parseStr);
                }
            }
        } catch(SQLException e){
            WFSUtil.printErr(engineName,"", e);
        } catch(Exception e){
            WFSUtil.printErr(engineName,"", e);
        } finally{
        	try{
            	if(rs!=null){
            		rs.close();
            		rs=null;
            	}
            } catch(Exception e){
            	WFSUtil.printErr(engineName,"", e);
            }
            try{
            	if(pstmt!=null){
            		pstmt.close();
            		pstmt=null;
            	}
            } catch(Exception e){
            	WFSUtil.printErr(engineName,"", e);
            }
        }
        return todoStatMap;
    }

}