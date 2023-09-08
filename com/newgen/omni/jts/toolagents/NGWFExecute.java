//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: NGWFExecute.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: implementation of mail Tool Agent .
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 19/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.toolagents;

import java.util.HashMap;
import java.util.Vector;

import com.newgen.omni.jts.util.WFSUtil;

public class NGWFExecute
  implements WFToolAgent {

  public int app_status = 0;

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMTAConnect
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	String TAName, String username ,String password
//	Output Parameters			:   none
//	Return Values				:	int
//	Description					:   Connects to the Tool Agent and returns the Session Handle.
//----------------------------------------------------------------------------------------------------
  public int WMTAConnect(String TAName, String username, String password) {
    return 0;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMTADisConnect
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	int TA_handle
//	Output Parameters			:   none
//	Return Values				:	int
//	Description					:   Disconnects the Tool Agent Session Handle.
//----------------------------------------------------------------------------------------------------
  public int WMTADisConnect(int TA_handle) {
    return 0;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMTAInvokeApplication
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	int TA_handle, String app_name , String processInst , int workItem , Vector attributeList , int appmode
//	Output Parameters			:   none
//	Return Values				:	int
//	Description					:   Reads the Appropriate Attributes from the Attribute List and performs the requested Application Task
//----------------------------------------------------------------------------------------------------
  public int WMTAInvokeApplication(int TA_handle, String app_name, String processInst, int workItem,
    Vector attributeList, int appmode) {
    // This code is written temporarly. When design changes then It should be changed.
    int errorCode = 0;
    try {
      String attrib = replaceAtribs((String) attributeList.elementAt(0),
        new Vector(((HashMap) attributeList.elementAt(1)).values()));
      if(app_name.equals("compute")) {
        // Execute method with Toeknized comma separated String values .
      }
    } catch(Exception e) {
      WFSUtil.printErr("", e);
      errorCode = -1;
    }
    return errorCode;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMTARequestAppStatus
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	int TA_handle, String processInst , int workItem
//	Output Parameters			:   none
//	Return Values				:	int
//	Description					:   Gives the status of applications if running synchronously.
//----------------------------------------------------------------------------------------------------
  public int WMTARequestAppStatus(int TA_handle, String processInst, int workItem) {
    return 0;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMTATerminateApp
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	int TA_handle, String processInst , int workItem
//	Output Parameters			:   none
//	Return Values				:	int
//	Description					:   Terminates the application underway.
//----------------------------------------------------------------------------------------------------
  public int WMTATerminateApp(int TA_handle, String processInst, int workItem) {
    app_status = TERMINATED;
    return 0;
  }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	replaceAtribs
//	Date Written (DD/MM/YYYY)	:	05/08/2002
//	Author						:	Prashant
//	Input Parameters			:	String original, Vector attributeList
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   replace Attributes in the given String
//----------------------------------------------------------------------------------------------------
  public String replaceAtribs(String original, Vector attributeList) {
    String[] attrib = null;
    for(int i = 0; i < attributeList.size(); i++) {
      attrib = (String[]) attributeList.elementAt(i);
      original = WFSUtil.replace(original, "&<" + attrib[0] + ">&", attrib[2]);
    }
    return original;
  }

} //end-Transaction
