/*----------------------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
                         Group : Phoenix
                       Product : OmniFlow
                        Module : 
                     File Name : ServiceCollection.java
                        Author : amangla
                  Date written : Aug 29, 2009
                   Description : This class keeps hashmap for caching system service object
 -----------------------------------------------------------------------------------------
                            CHANGE HISTORY
 -----------------------------------------------------------------------------------------
 Date		    Change By	    Change Description (Bug No. If Any)
 05/07/2012  	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 05/01/2016     Anwar Danish    Multiple Instance of utilities is running with same session
 19/07/2016     Anwar Danish    Bug 62754 - In OFServices if a utility thread gets stuck then user is not able to restart that utility
 24/05/2019		Mohnish Chopra	Removing Sychronized from getService method as multiple issues have 
 								been reported where Services get Stuck if load or initialization of one service fails 
 16/04/2020     Chitranshi Nitharia Bug 91524 - Framework to manage custom utility via ofservices
 ---------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.cache;

import com.newgen.omni.jts.service.WFServiceInfo;
import com.newgen.omni.jts.service.WFServiceMaster;
import com.newgen.omni.jts.util.WFSUtil;
import java.util.HashMap;
import com.newgen.omni.wf.util.app.*;
import com.newgen.omni.wf.util.xml.XMLParser;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.wf.util.app.data.RegistrationInfo;
import com.newgen.omni.wf.util.xml.api.CreateXML;
import com.newgen.omni.wf.util.xml.api.WFCallBroker;

public class ServiceCollection {
	private static ServiceCollection serviceCollection = new ServiceCollection();
	private HashMap<String, ServiceFramework> serviceMap = new HashMap<String, ServiceFramework>();
	
	private ServiceCollection(){
		/**
		 * private constructor for singletom behaviour
		 */
	}
	
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getReference
//	Date Written (DD/MM/YYYY)	:	Aug 29, 2009
//	Author						:	Ashish Mangla
//	Input Parameters			:	None
//	Output Parameters			:   None
//	Return Values				:	reference to this class (singleton)
//	Description					:   returns singletom instance of this class fo rgetting cached servce
//----------------------------------------------------------------------------------------------------	
	public static ServiceCollection getReference(){
		return serviceCollection;
	}

	
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	
//	Date Written (DD/MM/YYYY)	:	Aug 29, 2009
//	Author						:	Ashish Mangla
//	Input Parameters			:	
//	Output Parameters			:   
//	Return Values				:	
//	Description					:   
//----------------------------------------------------------------------------------------------------	
	public  ServiceFramework getService(WFServiceInfo svcInfo){
//        WFSUtil.printOut("[ServiceCollection] getService() : ");
		String serviceType = null;
		String mainClassName = null;
		ServiceFramework svcFramework = null;
		char char21 = 21;
		String string21 = "" + char21;
		
//		svcFramework = serviceMap.get(svcInfo.getServiceId() + "");     
        svcFramework = serviceMap.get(svcInfo.getEngineName() + string21 + svcInfo.getServiceId());     //  For services on multiple cabinets.  Added Abhishek.
        String engineName = svcInfo.getEngineName();
        if (svcInfo.getServiceId() == 0) {
            if (svcFramework == null) {
                svcInfo.setSessionId("12345");
                try {
                    Class dynamicClass = Class.forName("com.newgen.omni.wf.monitorservice.MonitorUtility");
                    Constructor dynamicConstruct = dynamicClass.getConstructor(XMLParser.class);
                    Object dynamicObject = dynamicConstruct.newInstance(svcInfo.getParser());
                    svcFramework = (ServiceFramework) dynamicObject;
                    svcFramework.setCoreXML(svcInfo.getParser());
                    svcFramework.setInitializeStatus(true);
                    serviceMap.put(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), svcFramework);
                } catch (Throwable th) {
                    //th.printStackTrace();
                	WFSUtil.printErr(engineName, "",th);
                }
            } else if (svcInfo.getSessionId() == null || svcInfo.getSessionId().equals("")) {
                return null;
            }
            return svcFramework;
        }
		
            if (svcFramework == null || (svcInfo.getSessionId() == null && isSessionInvalid(svcFramework.getRegInfo(), svcFramework.getRegInfo().getSessionId()))) {
            WFSUtil.printOut(engineName,"[ServiceCollection] getService() : Creating new Object.");
				/**Todo
				 * create logic for class
				 * also call its load function...
				 * save it the hashmap also for the next time....
				 *
				 */
			
			serviceType = svcInfo.getServiceType();	//Process Server / Mailing Agent ....
                if (serviceType.equalsIgnoreCase(WFSConstant.CONST_CUSTOM_INTEGRATED_SERVICE)) {
                    mainClassName = svcInfo.getParser().getValueOf("ServiceClass");
                } else {
                    mainClassName = WFServiceMaster.getReference().getMainClass(serviceType);
                }
			try {
                WFSUtil.printOut(engineName,"MainClassName : " + mainClassName);
                Class dynamicClass = Class.forName(mainClassName);
                Constructor dynamicConstruct = dynamicClass.getConstructor(XMLParser.class);
                Object dynamicObject = dynamicConstruct.newInstance(svcInfo.getParser());
                svcFramework = (ServiceFramework) dynamicObject;				
				if(serviceType.equals(WFSConstant.CONST_ARCHIVE)){				
					Method method = svcFramework.getClass().getMethod("setTypeOfUtility", new Class[]{Integer.TYPE});
					method.invoke(svcFramework, new Object[]{1});
				} else if(serviceType.equals(WFSConstant.CONST_SHAREPOINT)){
					Method method = svcFramework.getClass().getMethod("setTypeOfUtility", new Class[]{Integer.TYPE});
					method.invoke(svcFramework, new Object[]{2});
				}
            } catch (ClassNotFoundException ex) {
				//ex.printStackTrace();
				WFSUtil.printErr(engineName,"ServiceCollection>> getService>>ClassNotFoundException" + ex);
			} catch (InstantiationException ex) {
				WFSUtil.printErr(engineName,"ServiceCollection>> getService>>InstantiationException" + ex);
			} catch (IllegalAccessException ex) {
				WFSUtil.printErr(engineName,"ServiceCollection>> getService>>IllegalAccessException" + ex);
			} catch	(ClassCastException ex) {
				WFSUtil.printErr(engineName,"ServiceCollection>> getService>>ClassCastException" + ex); //Invalid utility name provided....
			} catch (InvocationTargetException ex){
                WFSUtil.printErr(engineName,"ServiceCollection>> getService>>InvocationTargetException" + ex);
            } catch (NoSuchMethodException ex){
                WFSUtil.printErr(engineName,"ServiceCollection>> getService>>NoSuchMethodException" + ex);
            }
			serviceMap.put(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(),  svcFramework);
            if(svcFramework!=null){
				svcFramework.setCoreXML(svcInfo.getParser());            //  Added Abhishek. To populate Registration info and initialize logger.
	            WFSUtil.printOut(engineName,"[ServiceCollection] getService() : Object created and set successfully : ");
				boolean bInitialize = svcFramework.initialize();       // To load the resources.
	            svcInfo.setSessionId(svcFramework.getRegInfo().getSessionId());
	            svcFramework.setInitializeStatus(bInitialize);
	            WFSUtil.printOut(engineName,"[ServiceCollection] getService() : Initialize status : " + bInitialize);
            }else{
            	WFSUtil.printOut(engineName,"svcFramework is null");
            }
            } else if (svcInfo.getSessionId() == null) {
                svcInfo.setDuplicateInstance(true);
                return null;
            } else if (isSessionInvalid(svcFramework.getRegInfo(), svcInfo.getSessionId())) {
                WFSUtil.printOut(engineName, "[ServiceCollection] [getService] Stopped Instance");
                return null;
            }
		return svcFramework;
	}

	public void removeService(String strServiceKey, String engineName){
        WFSUtil.printOut(engineName,"[ServiceCollection] removeService() : Service object found : " + ServiceCollection.getReference().getServicesMap().get(strServiceKey) + "for key : " + strServiceKey);
        ServiceCollection.getReference().getServicesMap().remove(strServiceKey);
	}

    public HashMap<String, ServiceFramework> getServicesMap(){
        return ServiceCollection.getReference().serviceMap;
	}
	 /**
     This method will check if any new thread of same service is running or not
     @param svcInfo
     @return If a new thread of same service is running then returns true else false
    */
    public boolean isServiceRunning(WFServiceInfo svcInfo) {
        boolean isServiceRunning = false;
        ServiceFramework svcFramework = serviceMap.get(svcInfo.getEngineName() + "#" + svcInfo.getServiceId());
        if (svcFramework != null) {
            isServiceRunning = !isSessionInvalid(svcFramework.getRegInfo(), svcFramework.getRegInfo().getSessionId());
        }
        return isServiceRunning;
    }

    /**
     This method will validate the session
     @param regInfo RegistrationInfo object of service
     @param sessionId Session which need to validate
     @return If the session is valid then returns true else false
    */
    private boolean isSessionInvalid(RegistrationInfo regInfo, String sessionId) {
        boolean isSessionInvalid = false;
        try {
            String inputXML = CreateXML.WFIsSessionValid(regInfo.cabName, sessionId, "").toString();
            String outputXML = WFCallBroker.makeCall(regInfo, inputXML);
            XMLParser parser = new XMLParser(outputXML);
            if (parser.getValueOf("MainCode").equals("11")) {
                isSessionInvalid = true;
            }
        } catch (Exception ex) {
            WFSUtil.printErr(regInfo.cabName, ex);
        }
        return isSessionInvalid;
    }

}
