//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSCallBroker.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 31/12/2009
// Description				: For invoking ngEjbClient.makeCall 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
//  03/06/2013           Kahkeshan       Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.srvr;

import com.newgen.omni.jts.dataObject.WFTMSInfo;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.wf.util.app.*;
import com.newgen.omni.wf.util.excp.NGException;



public class WFTMSCallBroker {
	static private WFTMSCallBroker callBroker = new WFTMSCallBroker();
	static NGEjbClient ngEjbClient = null;
	
	/**
	 * *************************************************************
	 * Function Name    :	WFTMSProperty
	 * Author			:   Saurabh Kamal
	 * Date Written     :   25/03/2009 
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Constructor for WFTMSProperty
	 *						
	 * *************************************************************
	 */
	public WFTMSCallBroker() {
//		try {
//			WFTMSUtil.printOut("Within TMSCallBroker custructor::1111");
//			ngEjbClient = NGEjbClient.getSharedInstance();
//			WFTMSUtil.printOut("Within TMSCallBroker custructor::2222");
//		} catch (Exception ex) {
//			WFTMSUtil.printErr("Call Broker Error:::", ex);
//		}
	}
	
	/**
	 * *************************************************************
	 * Function Name    :	getSharedInstance
	 * Author			:   Saurabh Kamal
	 * Date Written     :   25/03/2009 
	 * Input Parameters :   NONE
	 * Return Value     :   NONE
	 * Description      :   Returns reference of WFTMSProperty
	 * *************************************************************
	 */
//	public static WFTMSCallBroker getSharedInstance() {
//		return callBroker;
//	}
	
	public static String execute(String strInput, WFTMSInfo wfTMSInfo){
		WFTMSUtil.printOut("", "Within TMSCallBroker:::::execute::::1111");
		String strOutput = "";		
		try{
			WFTMSUtil.printOut("", "Within TMSCallBroker:::::execute::::2222");
			ngEjbClient = NGEjbClient.getSharedInstance();
			WFTMSUtil.printOut("", "Within TMSCallBroker:::::execute::::3333");
			strOutput = ngEjbClient.makeCall(wfTMSInfo.getTargetAppServerIp(),String.valueOf(wfTMSInfo.getTargetAppServerPort()),wfTMSInfo.getTargetAppServerType(),strInput);
			WFTMSUtil.printOut("", "Within TMSCallBroker:::::execute::::outXML:::"+strOutput);
		} catch(NGException nEx){
			WFTMSUtil.printOut("", "Withing NGException......WFTMSCallBroker.java::");			
			//WFTMSUtil.printErr(""+e);
			WFTMSUtil.printErr("" ,nEx);
		} catch(Exception ex){
			WFTMSUtil.printOut("", "Withing Exception......WFTMSCallBroker.java::");			
			//ex.printStackTrace();
			WFTMSUtil.printErr("" ,ex);
		}
		
		return strOutput;
		
	}

}
