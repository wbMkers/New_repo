//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: NGOAckMailApp.java	
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: implementation of Acnowledgement Email Tool Agent .
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

import java.util.Date;
import java.util.Properties;
import java.util.Vector;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;

import com.newgen.omni.jts.util.WFSUtil;

public class NGOAckMailApp
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
      prop.load(new java.io.FileInputStream("AckMailApp.ini"));
    } catch(Exception e) {}
    smtpSv = prop.getProperty("mail.smtp.host", "127.0.0.1");
    WFSUtil.printOut("",smtpSv);
    prop.setProperty("mail.smtp.host", smtpSv);
    int i = 0;
    while(i < attributeList.size()) {
      attrib = (String[]) attributeList.elementAt(i);
      if(attrib[0].trim().equalsIgnoreCase("ApplicantEmailId")) {
        mailTo = attrib[2];
        // Code to send mail to the mail id
        Session session = Session.getDefaultInstance(prop, null);
        try {
          InternetAddress[] addr = {new InternetAddress(mailTo)};
          Message msg = new com.sun.mail.smtp.SMTPMessage(session,
            new java.io.FileInputStream("AcknowlegementEmail.eml"));
          msg.setFrom(new InternetAddress(prop.getProperty("From",
            java.net.InetAddress.getLocalHost().getHostAddress())));
          msg.setSubject("Acknowledgement");
          msg.setSentDate(new Date());
          /*					msg.setText("Dear Customer, \n"
             +"                We have recieved your application for opening an account with us. \n"
                                                 +"Regards,\n"
                                                 +"COMPANY.");
           */msg.setRecipients(Message.RecipientType.TO, addr);
          Transport.send(msg);
        } catch(javax.mail.internet.AddressException e) {
          WFSUtil.printErr("", e);
          errorCode = -1;
          break;
        } catch(javax.mail.MessagingException e) {
          WFSUtil.printErr("", e);
          errorCode = -1;
          break;
        } catch(Exception e) {
          WFSUtil.printErr("", e);
          errorCode = -1;
          break;
        }
        break;
      }
      i++;
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

} //end-Transaction
