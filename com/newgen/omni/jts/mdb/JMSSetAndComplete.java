//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: JMSSetAndComplete.java
//	Author					: Virochan
//	Date written (DD/MM/YYYY): 19/09/2005
//	Description				: Gets Messages from the destination and puts those messages in WFJMSMessageTable in the appropriate cabinet
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// 16/11/2005				Virochan        Requirement WFS_6.1_056
// 22/12/2005				Virochan		Restruturing of MDB in order to be more error tolerant 
// 26/12/2005				Virochan		Method insertInWFJMSMessageTable() removed. Appended in class WFSUtil.
// 26/05/2006				Virochan		Requirement SRU_6.2_010. Changes done for Websphere AS as Queue Names and Topic Names in 
//											websphere come like "queue:///[QueueName] and topic://[TopicName]?brokerversion=1 respectively.
// 19/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 15/01/2008               Varun Bhansaly  getJMSDestination() invoked over Message Object has been implemented differently 
//                                          by application servers, Logic modified to overcome this limitation.
// 01/02/2012				Vikas Saraswat	Bug 30380 - removing extra prints from console.log of omniflow_logs 
//----------------------------------------------------------------------------------------------------


package com.newgen.omni.jts.mdb;

import java.util.*;
import java.io.*;
import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;
import javax.jms.Topic;
import javax.jms.Queue;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;

//mappedName = "/queue/TestQ",
@MessageDriven(mappedName = "/queue/TestQ",activationConfig = {
    @ActivationConfigProperty(propertyName = "acknowledgeMode", propertyValue = "Auto-acknowledge"),
    @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "javax.jms.Queue"),
    @ActivationConfigProperty(propertyName="destination", propertyValue="/queue/TestQ") 
})
@TransactionManagement( TransactionManagementType.BEAN )


public class JMSSetAndComplete implements MessageListener {    
    private WFDestinationMapping destinationMapping = WFDestinationMapping.getReference();  
	
	public JMSSetAndComplete() {
	
	}	

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	onMessage
//	Date Written (DD/MM/YYYY)	:	19/09/2005
//	Author						:	Virochan
//	Input Parameters			:	Message
//	Output Parameters			:   none
//	Return Values				:	void
//	Description					:   Gets the message and insert this message into WFJMSMessageTable
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
// Changed By				: Virochan
// Change Description       : Restruturing of MDB in order to be more error tolerant 
// Date                     : 22/12/2005
//----------------------------------------------------------------------------------------------------
    
	@Override
	public void onMessage(Message inMessage) {
        WFSUtil.printOut("","[JMSSetAndComplete] In onMessage");
        TextMessage message = null;
		String jmsMessage = "";
		String destination = "";
		String cabinet = "";
        String key = "";
        Set destinationNameskeySet = null;
        HashMap destinationMap = null;
        Iterator iter = null;
        if(destinationMapping.isMapNull()){
	        try{
				destinationMapping.readMappingFromFile();
                                
			}catch(Exception ex){
                WFSUtil.printErr(cabinet,"[JMSSetAndComplete] ", ex);
				WFSUtil.writeLog(jmsMessage, cabinet, destination);
				return;
			}
		}
        destinationMap = destinationMapping.wfGetDestinationMappingMap();
        
        if(destinationMap != null){
            destinationNameskeySet = destinationMap.keySet();
            if(destinationNameskeySet != null){
                iter = destinationNameskeySet.iterator();
            }
        }
        try{
			message = (TextMessage)inMessage;
		}catch(ClassCastException ccex){
			WFSUtil.printErr("","[JMSSetAndComplete] Ignoring Exception >> ", ccex);
			return;
		}
		try{
			jmsMessage = message.getText();
            /**
              *  message.getJMSDestination() gives the User Friendly name of the JMS Destination. It doesnot give the JNDI Name.
              *  1. In case of WebLogic 9.2, it gives, <SystemModuleName>!<JMSDestinationName>
              *  2. In case of JBoss 3.x/ 4.0.x, if JMS Destination has JNDI Name as topic/JMSTopic, then message.getJMSDestination()
              *     gives JMSTopic.
             **/
			Object obj = message.getJMSDestination(); 
			if (obj instanceof javax.jms.Queue){
				Queue queue = (Queue)message.getJMSDestination();
				destination = queue.getQueueName();
				
				//SRU_6.2_010
				if(destination.startsWith("queue:///WQ_")){
					destination = destination.substring(12);
				}
				WFSUtil.printOut(cabinet,"[JMSSetAndComplete] Destination (Queue):: "+destination);
			}else if(obj instanceof javax.jms.Topic){
				Topic topic = (Topic)message.getJMSDestination();
				destination = topic.getTopicName();
				
				//SRU_6.2_010
				if(destination.startsWith("topic://")){
					destination = destination.substring(8);
					destination = destination.substring(0, destination.lastIndexOf("?"));
				}
				WFSUtil.printOut(cabinet,"[JMSSetAndComplete] Destination (Topic):: "+destination);
			}else{
				WFSUtil.printOut(cabinet,"[JMSSetAndComplete] Message is not from either topic or queue");
				return;				
			}
	  	}catch(ClassCastException ccex){
			WFSUtil.printErr(cabinet,"", ccex);
		}catch(JMSException jmsex){
			WFSUtil.printErr(cabinet,"", jmsex);
		}catch(Exception ex){
			WFSUtil.printErr(cabinet,"", ex);
		}
        /** 
          * 
         **/
        while(iter!=null && iter.hasNext()){
            key = (String)iter.next();
            if(destination.endsWith(key)){
                iter = null;
                break;
            }
        }
        WFSUtil.printOut(cabinet,"[JMSSetAndComplete] Key >> " + key);
    	ArrayList cabinetList = destinationMapping.getCabinetList(key);
		if(cabinetList != null){
			for(int cabinetCount = 0; cabinetCount < cabinetList.size(); cabinetCount++){
				cabinet = (String)cabinetList.get(cabinetCount);
				WFSUtil.insertInWFJMSMessageTable(jmsMessage, key, cabinet);
			}
		}else{
		    WFSUtil.writeLog(jmsMessage, cabinet, destination);
		}
	}
}