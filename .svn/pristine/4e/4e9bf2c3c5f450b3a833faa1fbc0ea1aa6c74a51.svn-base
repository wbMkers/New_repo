//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group							: Application �Products
//Product / Project				: WorkFlow
//Module						: EJB
//File Name						: WFSEjbApi.java
//Author						: Ashish Mangla
//Date written (DD/MM/YYYY)		: 17/12/2004
//Description					: Main Bean for WFClientServiceHandlerBean
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 15/12/2006   Shilpi          Bug#369
// 07/04/2009	Prateek Tandon  WFS_6.2_078 Removal of password tag from wrapper logs and wrapper logs made configurable.Change in architecture of wrapper.
// 10/07/2012  	Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
// 04/05/2018	Mohnish Chopra	Bug 1032984 - Dual IP Port support required for Server API Calls through wrapper 
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.client;

import java.io.*;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.app.NGEjbClient;
	
public class WFSEjbApi implements NGOEjbInterface{

    private WFSClientProp clientProp = null;

    public WFSEjbApi(){
		clientProp = WFSClientProp.getReference();
    }

    //----------------------------------------------------------------------------------------------------
    //Function Name 		:	ngoExecuteCall
    //Date Written (DD/MM/YYYY): 1/04/2002
    //Author				: Sarathy
    //Input Parameters		: InputXml,Indicator.
    //Output Parameters		: String containing OutputXml for the call
    //Return Values			:
    //Description			: It is used for routing of calls based on the indicator.
    //----------------------------------------------------------------------------------------------------
    public String ngoExecuteCall(String strInputXML){
    	//String engine = "";
    	WFSUtil.printOut("","[WFSEjbAPI] ngoExecuteCall()");
    	boolean connected = false;
    	//if(WFSUtil.isLogEnabled('X', Level.DEBUG)){ 
    	//String InputXml = Utility.changePassword(strInputXML);
    	//WFSUtil.writeLog(InputXml, ""); 
    	//}
    	String strReturn = new String();
    	try
    	{
    		String strIP = clientProp.getJndiServerName();
    		String[] arrayOfIPs = null;
    		String[] strJndiPortLists = null;
    		String strPort = clientProp.getJndiServerPort();
    		WFSUtil.printOut("","[WFSEjbAPI] strIP--"+strIP+"--strPort--"+strPort);
    		if (strIP.indexOf(",") != -1)
    		{
    			arrayOfIPs= strIP.split(",");
    			strJndiPortLists = strPort.split(",");
    			for (int i = 0 ; i < arrayOfIPs.length ; i++)
    			{
    				try { 
    					if(connected){
    						break;
    					}
    					strIP = arrayOfIPs[i];
    					strPort = strJndiPortLists[i];
    					//WFSUtil.printOut("","[WFSEjbAPI] 1 strIP--"+strIP+"--strPort--"+strPort);
    					strReturn = NGEjbClient.getSharedInstance().makeCall(strIP, strPort, clientProp.getApplicationServerName(), strInputXML,clientProp.getClusterName(),"");
    					connected = true;
    					//if(WFSUtil.isLogEnabled('X', Level.DEBUG)) 
    					WFSUtil.writeLog("", Utility.changePassword(strReturn));						
    				}
    				catch(Exception ex) {
    					WFSUtil.printErr("", ex);
    					connected = false;
    				}
    			}
    		}
    		else {
    			strReturn = NGEjbClient.getSharedInstance().makeCall(strIP, strPort, clientProp.getApplicationServerName(), strInputXML,clientProp.getClusterName(),"");
    			connected = true;
    			//if(WFSUtil.isLogEnabled('X', Level.DEBUG)) 
    			WFSUtil.writeLog("", Utility.changePassword(strReturn));
    		}
    	}
    	catch(Exception exception)
    	{
    		WFSUtil.printErr("", exception);     
	   }
    	return strReturn;
    }
}
