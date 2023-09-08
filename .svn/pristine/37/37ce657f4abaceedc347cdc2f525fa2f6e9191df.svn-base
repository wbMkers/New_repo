//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Phoenix
//	Product / Project			: iBPS
//	Module					: Transaction Server
//	File Name				: WFActivityCache.java
//	Author					: Sourabh Tantuway
//	Date written (DD/MM/YYYY)	        : 28/07/2020
//	Description				: 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date					Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.dataObject.WFActivityInfo;
import java.sql.*;
import java.util.HashMap;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.jts.srvr.ServerProperty;

public class WFSAPCache extends cachedObject {
	 XMLGenerator gen;
	  public String xml;

    protected void setEngineName(String engineName) {
        this.engineName = engineName;
    }

    protected void setProcessDefId(int processDefId) {
        this.processDefId = processDefId;
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 					:	create
//	Date Written (DD/MM/YYYY)		:	27/07/2020
//	Author							:	Sourabh Tantuway
//	Input Parameters				:	Object key
//	Output Parameters				:	none
//	Return Values					:	Object
//	Description						:   Retruns SAP connection data xml
//----------------------------------------------------------------------------------------------------
    protected Object create(Connection con, String key) {
    	int confid = Integer.parseInt(key);
        StringBuffer outputXml = new StringBuffer(100);
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String pa_ss_word_SAP=null;

        try {
        	gen = new XMLGenerator();
            pstmt = con.prepareStatement("SELECT Processdefid, SAPHostName, SAPInstance, SAPClient, SAPUserName, SAPPassword, SAPHttpProtocol, SAPITSFlag, SAPLanguage, SAPHttpPort, ConfigurationID, RFCHostName, ConfigurationName, SecurityFlag  FROM WFSAPConnectTable where processDefId = ?" + (confid > -1?" AND ConfigurationId = "+confid:" "));
            pstmt.setInt(1, processDefId);
            pstmt.execute();
            rs = pstmt.getResultSet();
            outputXml.append("<WFSAPConnectionInfo>");   
            if(rs != null){
                while(rs.next()){
                	outputXml.append("<WFSAPConnectionDetails>");      
                    outputXml.append(gen.writeValueOf("SAPHostName", rs.getString(2)));
                    outputXml.append(gen.writeValueOf("SAPInstance", rs.getString(3)));
                    outputXml.append(gen.writeValueOf("SAPClient", rs.getString(4)));
                    outputXml.append(gen.writeValueOf("SAPUserName", rs.getString(5)));
					String securityFlag=rs.getString(14);
                    if(securityFlag!=null && securityFlag.equalsIgnoreCase("Y"))
                    	pa_ss_word_SAP=Utility.decode(rs.getString(6));
                    else
                    	pa_ss_word_SAP=rs.getString(6);
                    outputXml.append(gen.writeValueOf("SAPPassword", pa_ss_word_SAP));
                    //outputXml.append(gen.writeValueOf("SAPPassword", Utility.decode(rs.getString(6))));
                    outputXml.append(gen.writeValueOf("SAPHttpProtocol", rs.getString(7)));
                    outputXml.append(gen.writeValueOf("SAPITSFlag", rs.getString(8)));
                    outputXml.append(gen.writeValueOf("SAPLanguage", rs.getString(9)));
                    outputXml.append(gen.writeValueOf("SAPHttpPort", rs.getString(10)));
                    outputXml.append(gen.writeValueOf("ConfigurationID", String.valueOf(rs.getInt(11))));
                    outputXml.append(gen.writeValueOf("RFCHostName", rs.getString(12)));
					outputXml.append(gen.writeValueOf("ConfigurationName", String.valueOf(rs.getString(13))));
                    outputXml.append("</WFSAPConnectionDetails>"); 

			    }
               
                rs.close();
                rs = null;
            }
            outputXml.append("</WFSAPConnectionInfo>");
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            
        } catch (SQLException e) {
            WFSUtil.printErr(engineName,"", e);
        } catch (Exception e) {
            WFSUtil.printErr(engineName,"", e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }

        }
        
        return outputXml.toString();
    }

    
}
