//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
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
// 16/05/2005           Ashish Mangla       CacheTime related changes / removal of thread, no static												hashmap
// 18/10/2007			Varun Bhansaly		SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 29/08/2008			Shweta Tyagi		SrNo-2  Added VariableId and VarFieldId to provide Complex												Data Type Support
// 08/04/2009			Saurabh Kamal       OFME Support
// 17/06/2009			Ashish Mangla		WFS_8.0_008 (DocTypes in combo should come in sorted order of doc type name)
// 28/07/2010			Saurabh Sinha		WFS_8.0_115 : Liberty (Data class & Search Functionality) (Intermediate Check - in)
// 01/02/2012			Vikas Saraswat		Bug 30380 - removing extra prints from console.log of omniflow_logs
// 05/07/2012           Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 30/05/2013           Kahkeshan           Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFDataClassInfo;
import com.newgen.omni.jts.dataObject.WFDocDataClassMapping;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.util.WFSUtil;
import java.sql.Statement;

public class WFDocumentDefinition
		extends cachedObject {

	XMLGenerator gen;
	String key;
	public String xml;
	//WFS_8.0_115
    private StringBuffer retValBuff = new StringBuffer();
    private HashMap<String,String> docIdStrMap = new HashMap<String, String>();

	protected void setEngineName(String engineName) {
		this.engineName = engineName;
	}

	protected void setProcessDefId(int processDefId) {
		this.processDefId = processDefId;
	}

        //WFS_8.0_115
        public String getDocIdMap(String docId)
        {
            docId = docIdStrMap.get(docId);
            return docId;
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

	protected Object create(Connection con, String key) {

		int dbType = ServerProperty.getReference().getDBType(engineName);
		char char21 = 21;
		String string21 = "" + char21;
		int index = key.indexOf(string21);
		char char25 = 25;
		String string25 = "" + char25;
        int indexprocVar = key.indexOf(string25);
		int activityId = 0;
		String pdaFlag = "N";
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
        }

		StringBuffer doctypXml = new StringBuffer("<Definition>\n");
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		gen = new XMLGenerator();

//----------------------------------------------------------------------------
// Changed By						: Saurabh Kamal
// Reason / Cause (Bug No if Any)	: OFME Support
// Change Description				: Differend query execution on the basis of pdaFlag
// Date                             : 08/04/2009
//----------------------------------------------------------------------------
		try {   //WFS_8.0_115
			if (activityId == 0) {
				HashMap docDataClassMap = new HashMap();
				WFDocDataClassMapping mapping = null;

				String docName = "";
				String prevDocName = "";
				stmt = con.createStatement();
				stmt.execute("SELECT DocumenttypedefTable.DocName, WFDocTypeFieldMapping.DCName, FieldName, " +
							" VariableId, VarFieldId, MappedFieldType, MappedFieldName, FieldType " +
							" FROM WFDocTypeFieldMapping " + WFSUtil.getTableLockHintStr(dbType) + ", DocumentTypeDefTable " + WFSUtil.getTableLockHintStr(dbType) +
							" WHERE WFDocTypeFieldMapping.processdefid = DocumenttypedefTable.processdefid " +
							" AND WFDocTypeFieldMapping.docid = DocumenttypedefTable.docid" +
							" AND DocumenttypedefTable.processDefId = " + processDefId + " and DocumenttypedefTable.ProcessVariantId = 0 order by DocName");
				rs = stmt.getResultSet();

				while(rs.next()){
//					System.out.println("in cache " + docName);
					docName = rs.getString("DocName");
					if (!docName.equalsIgnoreCase(prevDocName)){
						mapping = new WFDocDataClassMapping(con, engineName, docName, rs.getString("DCName"));
						docDataClassMap.put(docName.toUpperCase(), mapping);
					}
					mapping.addMapping(rs.getString("FieldName") , rs.getInt("VariableId") , rs.getInt("VarFieldId"), rs.getString("MappedFieldType"), rs.getString("MappedFieldName"), rs.getString("FieldType"));
					prevDocName = docName;
				}
				return docDataClassMap;
			} else {
                        String tempStr = "";
                        String comStr = "";
//                        String docId = "";
//                        String tempDocId = "";
                        String dcName = "";
//                        StringBuffer retVal = new StringBuffer();
                        int flag = 1;
//                        pstmt = con.prepareStatement("select * from WFDocTypeFieldMapping where processdefid = "+processDefId+" order by DocID,DCName");
//                        pstmt.execute();
//                        ResultSet rs = pstmt.getResultSet();
//                        while(rs.next())
//                        {
//                            docId = rs.getString("DocID");
//                            dcName = rs.getString("DCName");
//                            tempStr = docId+"#"+dcName;
//                            WFSUtil.printErr(parser,"[DocumentTypeClass] tempStr>>"+tempStr);
//                            WFSUtil.printErr(parser,"[DocumentTypeClass] comStr>>"+comStr);
//                            if(!tempStr.equalsIgnoreCase(comStr))
//                            {
//                                WFSUtil.printErr(parser,"[DocumentTypeClass] flag>>"+flag);
//                                if(flag <= 0)
//                                {
//                                 retVal.append("</DataMappingInfos>");
//                                 docIdStrMap.put(tempDocId,retVal.toString());
//                                 retVal.setLength(0);
//                                 flag = 1;
//                                }
//                                retVal.append("<DataClassName>"+dcName+"</DataClassName>");
//                                retVal.append("<DataMappingInfos>");
//                            }
//                                retVal.append("<DataMappingInfo>");
//                                retVal.append("<FieldName>"+rs.getString("FieldName")+"</FieldName>");
//                                retVal.append("<FieldId>"+rs.getString("FieldId")+"</FieldId>");
//                                retVal.append("<VariableId>"+rs.getString("VariableId")+"</VariableId>");
//                                retVal.append("<VarFieldId>"+rs.getString("VarFieldId")+"</VarFieldId>");
//                                retVal.append("<MappedFieldType>"+rs.getString("MappedFieldType")+"</MappedFieldType>");
//                                retVal.append("<MappedFieldName>"+rs.getString("MappedFieldName")+"</MappedFieldName>");
//                                retVal.append("<FieldType>"+rs.getString("FieldType")+"</FieldType>");
//                                retVal.append("</DataMappingInfo>");
//                            comStr = tempStr;
//                            tempDocId = docId;
//                            flag--;
//                        }
//                        retVal.append("</DataMappingInfos>");
//                        docIdStrMap.put(tempDocId,retVal.toString());
//                        pstmt.close();

                        comStr = "";
                        tempStr = "";
                        flag = 1;
                        boolean iflag=false;
                        retValBuff.append("<SearchDocumentMapping>");
                        pstmt = con.prepareStatement("select * from WFDocTypeSearchMapping " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = "+processDefId+
                                " and activityid = "+activityId+" order by DCName");
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        while(rs.next())
                        {
                        	iflag=true;
                            dcName = rs.getString("DCName");
                            tempStr = dcName;
                            if(dcName == null || dcName.length() == 0)
                            {
                                dcName = "";
                                if(flag == 1)
                                {
                                    retValBuff.append("<SearchMapping>");
                                    retValBuff.append("<DataClassName>"+dcName+"</DataClassName>");
				    retValBuff.append("<SearchMappingInfos>");
                                }
                            }
                            else if(!tempStr.equalsIgnoreCase(comStr))
                            {
                                if(flag <= 0)
                                {
                                 retValBuff.append("</SearchMappingInfos>");
                                 retValBuff.append("</SearchMapping>");
                                 flag = 1;
                                }
                                retValBuff.append("<SearchMapping>");
                                retValBuff.append("<DataClassName>"+dcName+"</DataClassName>");
                                WFDataClassInfo classInfo = (WFDataClassInfo)CachedObjectCollection.getReference().getCacheObject(con, engineName, 0, WFSConstant.CACHE_CONST_DataClassCache, dcName).getData();
                                if (classInfo != null) {
                                        retValBuff.append("<DataClassId>"+ classInfo.getDataDefIndex() +"</DataClassId>");
                                }
								
                                retValBuff.append("<SearchMappingInfos>");
                           }
                                retValBuff.append("<SearchMappingInfo>");
								String fieldName = rs.getString("DCField");
                                retValBuff.append("<DataClassField>" + fieldName + "</DataClassField>");
								String  fieldId = (String)CachedObjectCollection.getReference().getCacheObject(con, engineName, 0, WFSConstant.CACHE_CONST_DataClassCache, dcName + string21 + fieldName).getData();
								if (fieldId != null){
									retValBuff.append("<FieldId>" + fieldId + "</FieldId>");
								} else {
									WFSUtil.printOut(engineName,"Check ! could no get FieldId for FieldName");
								}
                                retValBuff.append("<VariableId>"+rs.getString("VariableId")+"</VariableId>");
                                retValBuff.append("<VarFieldId>"+rs.getString("VarFieldId")+"</VarFieldId>");
                                retValBuff.append("<MappedFieldType>"+rs.getString("MappedFieldType")+"</MappedFieldType>");
                                retValBuff.append("<MappedFieldName>"+rs.getString("MappedFieldName")+"</MappedFieldName>");
                                retValBuff.append("<FieldType>"+rs.getString("FieldType")+"</FieldType>");
                                retValBuff.append("</SearchMappingInfo>");
                            comStr = tempStr;
                            flag--;
                          }
                        
                        if(iflag)
                        {
                        retValBuff.append("</SearchMappingInfos>");
                        retValBuff.append("</SearchMapping>");
                        }
                        retValBuff.append("</SearchDocumentMapping>");
                        doctypXml.append(retValBuff);
                        pstmt.close();

                        String docIdStr = "";

			HashMap docDataClassMapping = (HashMap)CachedObjectCollection.getReference().getCacheObject(con, engineName, processDefId , WFSConstant.CACHE_CONST_DocumentDefinition, "0").getData();

			iflag=false;
			if (pdaFlag.equals("Y")) {
                                if (processDefId != 0 && activityId != 0) {
					pstmt = con.prepareStatement("SELECT distinct DocId , DocName , Attribute , Param1 , Type1 , ExtObjId1 , VariableId_1, VarFieldId_1, Param2 , Type2 , ExtObjId2, VariableId_2, VarFieldId_2 FROM wfpdatable W " + WFSUtil.getTableLockHintStr(dbType) + ",DOCUMENTTYPEDEFTABLE A " + WFSUtil.getTableLockHintStr(dbType) + " , ACTIVITYINTERFACEASSOCTABLE c " + WFSUtil.getTableLockHintStr(dbType) + "  LEFT OUTER JOIN  SCANACTIONSTABLE B " + WFSUtil.getTableLockHintStr(dbType) + " ON C.ProcessDefId = B.ProcessDefID AND InterfaceElementId = B.DocTypeId AND c.ActivityId = B.ActivityId WHERE c.ActivityId = ?  AND c.ProcessDefId = ?  AND c.ProcessDefId = A.ProcessDefId  AND c.InterfaceType = 'D' AND InterfaceElementId = DocId and w.interfaceid = docid and c.interfacetype = w.interfacetype AND w.activityid = c.activityid AND C.ProcessVariantId = A.ProcessVariantId AND A.ProcessVariantId = 0 AND W.ActivityId = c.ActivityId AND W.ProcessDefId = c.ProcessDefId ORDER BY DocName ASC");//SrNo-2

					pstmt.setInt(1, activityId);
					pstmt.setInt(2, processDefId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					doctypXml.append("<DocumentTypes>\n");
					int docid = 0;
					int docid_old = 0;
					while (rs.next()) {
						iflag=true;
						docid = rs.getInt("DocId");
						String docName = rs.getString("DocName");
						if (docid != docid_old) {
							if (docid_old != 0) {
								doctypXml.append("</ScanActions>\n");
								doctypXml.append("</DocumentType>\n");
							}
							docid_old = docid;
                                                        docIdStr = String.valueOf(docid);//WFS_8.0_115
							doctypXml.append("<DocumentType>\n");
							doctypXml.append(gen.writeValueOf("DocumentTypeDefIndex", docIdStr));
							doctypXml.append(gen.writeValueOf("DocumentTypeDefName", rs.getString(2)));
							doctypXml.append(gen.writeValueOf("Attribute", rs.getString(3)));
							if (docDataClassMapping.containsKey(docName.toUpperCase())) {
								doctypXml.append(((WFDocDataClassMapping)docDataClassMapping.get(docName.toUpperCase())).getXML());
							}
							doctypXml.append("<ScanActions>\n");
						}
						String str = rs.getString(4);
						if (!rs.wasNull()) {
							doctypXml.append("<ScanAction>\n");
							doctypXml.append(gen.writeValueOf("Parameter1", str));
							doctypXml.append(gen.writeValueOf("Type1", rs.getString(5)));
							doctypXml.append(gen.writeValueOf("ExternalObjectId1", rs.getString(6)));
							doctypXml.append(gen.writeValueOf("VariableId1", rs.getString(7)));//SrNo-2

							doctypXml.append(gen.writeValueOf("VarFieldId1", rs.getString(8)));//SrNo-2

							doctypXml.append(gen.writeValueOf("Parameter2", rs.getString(9)));
							doctypXml.append(gen.writeValueOf("Type2", rs.getString(10)));
							doctypXml.append(gen.writeValueOf("ExternalObjectId2", rs.getString(11)));
							doctypXml.append(gen.writeValueOf("VariableId2", rs.getString(12)));//SrNo-2

							doctypXml.append(gen.writeValueOf("VarFieldId2", rs.getString(13)));//SrNo-2

							doctypXml.append("</ScanAction>\n");
						}
					}
					if(iflag){
					doctypXml.append("</ScanActions>\n");
					doctypXml.append("</DocumentType>\n");
					}
					doctypXml.append("</DocumentTypes>\n");
				}
				doctypXml.append("</Definition>\n");
				xml = doctypXml.toString();
			} else {
				if (processDefId != 0 && activityId != 0) {
                   String procVarSt = null;
                   if (dbType == JTSConstant.JTS_ORACLE) 
                   		procVarSt =" AND C.ProcessVariantId = A.ProcessVariantId AND A.ProcessVariantId in (TO_CHAR(?) , 0)";
                   else if(dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES)
                    	procVarSt =" AND C.ProcessVariantId = A.ProcessVariantId AND A.ProcessVariantId in (? , 0)";
                    pstmt = con.prepareStatement("SELECT DocId , DocName , Attribute , Param1 , Type1 , ExtObjId1 , VariableId_1, VarFieldId_1, Param2 , Type2 , ExtObjId2, VariableId_2, VarFieldId_2, A.ProcessVariantId ProcessVariantId FROM DOCUMENTTYPEDEFTABLE A " + WFSUtil.getTableLockHintStr(dbType) + " , ACTIVITYINTERFACEASSOCTABLE c " + WFSUtil.getTableLockHintStr(dbType) + "  LEFT OUTER JOIN  SCANACTIONSTABLE B " + WFSUtil.getTableLockHintStr(dbType) + " ON C.ProcessDefId = B.ProcessDefID AND InterfaceElementId = B.DocTypeId AND c.ActivityId = B.ActivityId WHERE c.ActivityId = ?  AND c.ProcessDefId = ?  AND c.ProcessDefId = A.ProcessDefId  AND InterfaceType = 'D' AND InterfaceElementId = DocId "+ procVarSt +" ORDER BY DocName ASC");//SrNo-2
                    pstmt.setInt(1, activityId);
					pstmt.setInt(2, processDefId);
                    pstmt.setInt(3, procVarId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					doctypXml.append("<DocumentTypes>\n");
					int docid = 0;
					int docid_old = 0;
                    int procVarId_old = 0;
					while (rs.next()) {
                        procVarId = rs.getInt("ProcessVariantId");
						docid = rs.getInt("DocId");
						String docName = rs.getString("DocName");
						if ((docid != docid_old )|| (docid == docid_old  && procVarId_old != procVarId)) {
							if (docid_old != 0) {
								doctypXml.append("</ScanActions>\n");
								doctypXml.append("</DocumentType>\n");
							}
							docid_old = docid;
                            procVarId_old = procVarId;
							docIdStr = String.valueOf(docid);//WFS_8.0_115
							doctypXml.append("<DocumentType>\n");
							doctypXml.append(gen.writeValueOf("DocumentTypeDefIndex", docIdStr));
							doctypXml.append(gen.writeValueOf("DocumentTypeDefName", rs.getString(2)));
							doctypXml.append(gen.writeValueOf("Attribute", rs.getString(3)));
                            doctypXml.append(gen.writeValueOf("VariantId", String.valueOf(procVarId)));
							if (docDataClassMapping.containsKey(docName.toUpperCase())) {//WFS_8.0_115
								doctypXml.append(((WFDocDataClassMapping)docDataClassMapping.get(docName.toUpperCase())).getXML());
							}
							doctypXml.append("<ScanActions>\n");
						}
						String str = rs.getString(4);
						if (!rs.wasNull()) {
							doctypXml.append("<ScanAction>\n");
							doctypXml.append(gen.writeValueOf("Parameter1", str));
							doctypXml.append(gen.writeValueOf("Type1", rs.getString(5)));
							doctypXml.append(gen.writeValueOf("ExternalObjectId1", rs.getString(6)));
							doctypXml.append(gen.writeValueOf("VariableId1", rs.getString(7)));//SrNo-2

							doctypXml.append(gen.writeValueOf("VarFieldId1", rs.getString(8)));//SrNo-2

							doctypXml.append(gen.writeValueOf("Parameter2", rs.getString(9)));
							doctypXml.append(gen.writeValueOf("Type2", rs.getString(10)));
							doctypXml.append(gen.writeValueOf("ExternalObjectId2", rs.getString(11)));
							doctypXml.append(gen.writeValueOf("VariableId2", rs.getString(12)));//SrNo-2

							doctypXml.append(gen.writeValueOf("VarFieldId2", rs.getString(13)));//SrNo-2

							doctypXml.append("</ScanAction>\n");
						}
					}
					doctypXml.append("</ScanActions>\n");
					doctypXml.append("</DocumentType>\n");
					doctypXml.append("</DocumentTypes>\n");
				}
				doctypXml.append("</Definition>\n");
				xml = doctypXml.toString();
			}
				 }
                } catch (SQLException e) {
			WFSUtil.printErr(engineName,"", e);
		} catch (Exception e) {
			WFSUtil.printErr(engineName,"", e);
		} finally {
			try {
				if(rs!=null){
					rs.close();
					rs=null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engineName,"", e);
			}
			try {
				if(stmt!=null){
					stmt.close();
					stmt=null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engineName,"", e);
			}
			try {
				if(pstmt!=null){
					pstmt.close();
					pstmt=null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engineName,"", e);
			}
			
		}

		return xml;
	}
}