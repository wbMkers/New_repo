//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group							: Application �Products
//Product / Project				: Omniflow 6.2
//Module						: Omniflow Server
//File Name						: WFSCustomEjbApi.java
//Author						: Ruhi Hira
//Date written (DD/MM/YYYY)		: 17/01/2008
//Description					: Client interface to execute custom beans. (Inherited from WFSEjbAPi)
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 13/05/2008	Ashish Mangla	Bugzilla Bug 5042 (outxml not returned)
// 07/04/2009	Prateek Tandon  WFS_6.2_078 Removal of password tag from wrapper logs and wrapper logs made configurable.Change in architecture of wrapper.
//10/07/2012  	Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.client;

import com.newgen.omni.jts.cmgr.XMLParser;
import java.io.*;
import com.newgen.omni.wf.util.app.*;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.misc.Utility;

public class WFSCustomEjbApi implements NGOEjbInterface{
    
	private WFSClientProp customClientProp = null;
    
	public WFSCustomEjbApi(){
		customClientProp = WFSClientProp.getReference();
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
        String strReturn = null;
  
        WFSUtil.printOut("","[WFSCustomEjbAPI] ngoExecuteCall()");
//		if(WFSUtil.isLogEnabled('X', Level.DEBUG))
//		{
//		  String InputXml = Utility.changePassword(strInputXML);
//		  WFSUtil.writeLog(InputXml, "");
//		}
        String InputXml = Utility.changePassword(strInputXML);
		  WFSUtil.writeLog(InputXml, "");
        try {
//			strReturn = NGEjbClient.getSharedInstance().makeCall(customClientProp.getJndiServerName(), customClientProp.getJndiServerPort(), customClientProp.getApplicationServerName(), strInputXML);
            strReturn = NGEjbClient.getSharedInstance().makeCall(customClientProp.getJndiServerName(), customClientProp.getJndiServerPort(), customClientProp.getApplicationServerName(), strInputXML,customClientProp.getClusterName(),"");	
//			if(WFSUtil.isLogEnabled('X', Level.DEBUG))
				WFSUtil.writeLog("", Utility.changePassword(strReturn));
        } catch (Exception ex) {
            WFSUtil.printErr("", ex);
			//WFSUtil.printErr(Level.DEBUG,"", ex);
        }
        return strReturn;
    }

}