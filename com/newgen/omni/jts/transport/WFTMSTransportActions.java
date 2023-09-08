//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSTransportActions.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 30/12/2009
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.transport;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.srvr.WFTMSCallBroker;
import com.newgen.omni.jts.util.WFTMSUtil;
import java.sql.Connection;
import java.util.ArrayList;

/**
 *
 * @author saurabh.kamal
 */
public abstract class WFTMSTransportActions {	
	/**
	 * *************************************************************
	 * Function Name    :	execute
	 * Author			:   Saurabh Kamal
	 * Date Written     :   26/12/2009
	 * Input Parameters :   Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType
	 * Return Value     :   input xml to be executed on target cabinet
	 * Description      :	method to call prepareXml 
	 * *************************************************************
	 */
	public String execute(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType) {
		String targetInputXml = null;		
		String outputXml = null;
		//WFTMSInfo wfTMSInfo = null;		
		try{                            
			WFTMSUtil.printOut("", "Within WFTMSTransportActions.....execute::");			
			WFTMSUtil.printOut("", "Within WFTMSTransportActions.....tEngineName::"+wfTMSInfo.getTargetCabinet());
			WFTMSUtil.printOut("", "Within WFTMSTransportActions.....tAppServerIp::"+wfTMSInfo.getTargetAppServerIp());
			WFTMSUtil.printOut("", "Within WFTMSTransportActions.....tAppServerPort::"+wfTMSInfo.getTargetAppServerPort());
			WFTMSUtil.printOut("", "Within WFTMSTransportActions.....tAppServerType::"+wfTMSInfo.getTargetAppServerType());
			targetInputXml = prepareXML(con, wfTMSInfo, xmlGen, reqId, sessionId, dbType);			
			if(targetInputXml != null && !targetInputXml.equals("")){
				outputXml = transportData(targetInputXml, wfTMSInfo);
			}			
		}catch(Exception e){
			WFTMSUtil.printErr("", ""+e);
		}
		return outputXml;
	}
	// call fillActionData
	/**
	 * *************************************************************
	 * Function Name    :	execute
	 * Author			:   Saurabh Kamal
	 * Date Written     :   26/12/2009
	 * Input Parameters :   Connection con, String reqId, ArrayList objectList, XMLParser inputXML
	 * Return Value     :   None
	 * Description      :	method to call fillActionData
	 * *************************************************************
	 */
	public int execute(Connection con, String reqId, ArrayList objectList, XMLParser inputXML) {		
		int mainCode = 0;
		try{
			WFTMSUtil.printOut("", "Within WFTMSTransportActions fillActionData.....execute");			
			mainCode = fillActionData(con, reqId, objectList, inputXML);
		}catch(Exception e){
			WFTMSUtil.printErr("", ""+e);
		}
		return mainCode;
	}
	abstract public String prepareXML(Connection con, WFTMSInfo wfTMSInfo, XMLGenerator xmlGen, String reqId, String sessionId, int dbType);
	abstract public int fillActionData(Connection con, String reqId, ArrayList objectList, XMLParser inputXML) throws JTSException, Exception;

	/**
	 * *************************************************************
	 * Function Name    :	transportData
	 * Author			:   Saurabh Kamal
	 * Date Written     :   26/12/2009
	 * Input Parameters :   None
	 * Return Value     :   None
	 * Description      :	method to call makeCall method of NGEjbCallBroker.
	 * *************************************************************
	 */
	
	public String transportData(String targetInputXML, WFTMSInfo wfTMSInfo){
		WFTMSUtil.printOut("", "Transporting Data to target Cabinet::");
		boolean status = false;
		int mainCode = 0;
		String outXML = null;
		XMLParser outParser = new XMLParser();
		try{
			WFTMSUtil.printOut("", "Transporting Data ::targetInputXML::"+targetInputXML);
			WFTMSUtil.printOut("", "Transporting Data ::tAppServerIp::"+wfTMSInfo.getTargetAppServerIp());
			WFTMSUtil.printOut("", "Transporting Data ::tAppServerPort::"+wfTMSInfo.getTargetAppServerPort());
			WFTMSUtil.printOut("", "Transporting Data ::tAppServerType::"+wfTMSInfo.getTargetAppServerType());
			outXML = WFTMSCallBroker.execute(targetInputXML, wfTMSInfo);
			outParser.setInputXML(outXML);
			mainCode = outParser.getIntOf("MainCode", -1, true);
			if(mainCode == 0){
				status = true;
			}
			WFTMSUtil.printOut("", "Data transrported::::");
		}catch(Exception e){
			status = false;
			WFTMSUtil.printErr("", ""+e);
		}
		return outXML;
	}
}
