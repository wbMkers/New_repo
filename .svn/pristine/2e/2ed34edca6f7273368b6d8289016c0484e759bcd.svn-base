/* ----------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow
Module				: Util
File Name			: WorkerThread.java
Author				: Kimil
Date written		: 22/11/2017
Description			: Worker thread for executing WFGetTaskList API.
-----------------------------------------------------------------------------------
CHANGE HISTORY
-----------------------------------------------------------------------------------
Date				Change By		Change Description (Bug No. If Any)
22/11/2017        Kumar Kimil     Multiple Precondition enhancement       
-------------------------------------------------------------------------------- */
package com.newgen.omni.jts.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;


import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.srvr.NGDBConnection;

import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.wf.util.xml.api.CreateXML;


public class WorkerThread implements Runnable {
	 
	private int sessionId;
	private int processdefId;
    private String engine;
    private String option;
	private String processInstanceId;
    private int workitemId;
    private int activityId;
    private String  oapWebServerAddress;
    private String  webServerAddress;
	
    public WorkerThread(String engine,String option,String processInstanceId,int workitemId,int activityId,int sessionId,int processDefId){
        this.engine=engine;
        this.option=option;
    	this.processInstanceId=processInstanceId;
        this.workitemId=workitemId;
        this.activityId=activityId;
        this.sessionId=sessionId;
        this.processdefId=processDefId;
        Properties httpInfo=WFServerProperty.getSharedInstance().getHttpInfo();
        
        this.oapWebServerAddress = httpInfo.getProperty("HTTPProtocolName")+httpInfo.getProperty("HTTPIP")+":"+httpInfo.getProperty("HTTPPort")+"/";
        this.webServerAddress = httpInfo.getProperty("HTTPProtocolName")+httpInfo.getProperty("HTTPIP")+":"+httpInfo.getProperty("HTTPPort")+"/";
    }

    @Override
    public void run() {
    	WFSUtil.printOut(Thread.currentThread().getName()+" Start. Command = "+processInstanceId);
    	Connection conn=null;
    	PreparedStatement pstmt=null;
    	String qry=null;
    	ResultSet rs=null;
        try {
        	Thread.sleep(5000);
        	conn = (Connection) NGDBConnection.getDBConnection(engine,option);
        	XMLParser parser=new XMLParser();
        	parser.setInputXML(CreateXML.WFGetTaskList(engine,sessionId,processInstanceId,workitemId,processdefId,activityId,webServerAddress,oapWebServerAddress).toString());
			processCommand(parser,conn);
			WFSUtil.printOut("!st thread call to taskList completed ");
			qry = "Select ProcessInstanceId,workitemId,ActivityId from WFTaskPreCheckTable where checkPreCondition=? and ProcessDefid=?";
			pstmt = conn.prepareStatement(qry);
			pstmt.setString(1, "Y");
			pstmt.setInt(2,processdefId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				parser=new XMLParser();
				parser.setInputXML(CreateXML.WFGetTaskList(engine,sessionId,rs.getString("ProcessInstanceId"),rs.getInt("workitemId"),processdefId,rs.getInt("ActivityId"),webServerAddress,oapWebServerAddress).toString());
				processCommand(parser,conn);
			}
			conn.close();
			WFSUtil.printOut(Thread.currentThread().getName()+" Ends.");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			WFSUtil.printOut("Exception in WorkerThread class"+e);
		}
		finally{
        	
				
        }
        
    }

    private void processCommand(XMLParser parser,Connection conn) throws Exception {
    	
    	try {
        	XMLGenerator gen=new XMLGenerator();
        	String output=WFFindClass.getReference().execute("WFGetTaskList", engine, conn, parser,gen);
        	WFSUtil.printOut(engine, "WFGetTaskList executed for thread-"+Thread.currentThread().getName()+"---outputXML="+output);
        	} //catch (InterruptedException e) {
//          //  e.printStackTrace();
//        		WFSUtil.printOut("Exception in processCommand "+e);
//        }
        	finally{
        		
        	}
    }

    @Override
    public String toString(){
        return "ProcessInstanceid="+this.processInstanceId +"; engine="+this.engine+"; option="+this.option;
    }
}