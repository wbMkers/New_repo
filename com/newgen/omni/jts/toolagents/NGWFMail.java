//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: NGWFMail.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: implementation of mail Tool Agent .
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	24/09/2002		Prashant		Changes for addition of FROM USER
//  19/10/2007		Varun Bhansaly			SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
//
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.toolagents;

import java.util.Date;
import java.util.HashMap;
import java.util.Properties;
import java.util.Vector;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;

import com.newgen.omni.jts.util.WFSUtil;

public class NGWFMail
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

    String mailTo = null;
    String smtpSv = null;
    String[] attrib = null;
    Properties prop = new Properties();
    int errorCode = 0;
    try {
      prop.load(new java.io.FileInputStream("NGWFMail.ini"));
    } catch(Exception e) {}
    smtpSv = prop.getProperty("mail.smtp.host", "127.0.0.1");

    prop.setProperty("mail.smtp.host", smtpSv);
    Session session = Session.getDefaultInstance(prop, null);
    try {
      InternetAddress[] addrTo = new InternetAddress[1];
      InternetAddress[] addrCC = new InternetAddress[1];
      try {
        addrTo[0] = new InternetAddress((String) attributeList.elementAt(2));
      } catch(Exception e) {}
      try {
        addrCC[0] = new InternetAddress((String) attributeList.elementAt(3));
      } catch(Exception e) {}

      Message msg = new com.sun.mail.smtp.SMTPMessage(session);

//--------------------------------------------------------------------------------------
// Changed By						: Prashant
// Reason / Cause (Bug No if Any)	: Changes for FROM USER addition
// Change Description				: set From as FROM USER if FROM USER is not null
//--------------------------------------------------------------------------------------

      if(!(attributeList.elementAt(4) == null || attributeList.elementAt(4).equals(""))) {
        msg.setFrom(new InternetAddress((String) attributeList.elementAt(4)));
      } else {
        msg.setFrom(new InternetAddress(prop.getProperty("From",
          java.net.InetAddress.getLocalHost().getHostAddress())));

      }
      try {
        msg.setSubject(replaceAtributes((String) attributeList.elementAt(0),
          new Vector(((HashMap) attributeList.elementAt(5)).values())));
      } catch(Exception e) {
        WFSUtil.printErr("", e);
      }

      msg.setSentDate(new Date());
      msg.setRecipients(Message.RecipientType.TO, addrTo);

      try {
        msg.setRecipients(Message.RecipientType.CC, addrCC);
      } catch(Exception e) {
        WFSUtil.printErr("", e);
      }

      try {
        msg.setText(replaceAtributes((String) attributeList.elementAt(1),
          new Vector(((HashMap) attributeList.elementAt(5)).values())));
      } catch(Exception e) {
        WFSUtil.printErr("", e);
      }

      Transport.send(msg);

    } catch(javax.mail.internet.AddressException e) {
      WFSUtil.printErr("", e);
      errorCode = -1;
    } catch(javax.mail.MessagingException e) {
      WFSUtil.printErr("", e);
      errorCode = -1;
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
      original = WFSUtil.replaceIgnoreCase(original, "&<" + attrib[0] + ">&",
        (attrib[2] == null ? "" : attrib[2]));
    }
    return original;
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
  public String replaceAtributes(String original, Vector attributeList) {
    com.newgen.omni.jts.dataObject.WMAttribute attrib = null;
    for(int i = 0; i < attributeList.size(); i++) {
      attrib = (com.newgen.omni.jts.dataObject.WMAttribute) attributeList.elementAt(i);
      original = WFSUtil.replaceIgnoreCase(original, "&<" + attrib.name + ">&",
        (attrib.value == null ? "" : attrib.value));
    }
    return original;
  }
} //end-Transaction
