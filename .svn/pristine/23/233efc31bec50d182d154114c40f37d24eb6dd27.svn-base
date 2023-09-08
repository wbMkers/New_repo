/*******************************************************************************
 *      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 *  Product         : OmniFlow
 *  Module          : OFServices
 *  File            : MonitorServiceManager.java
 *  Description     : This file is used to manage the Monitor Service
 *  Classes         : 
 *  Functions       : 
 *  Written By      : Ashutosh Pandey
 *  Date Written    : Jul 12, 2016
 *
 *  Change History  :
 *  Date            Change By           Change Description (Bug No. If Any)
 *  12/08/2016      Ashutosh Pandey     Bug 62455 - In OFServices if a utility thread gets stuck then user is not able to restart that utility
 ******************************************************************************/
package com.newgen.omni.jts.util;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.service.ServiceManagerClient;
import com.newgen.omni.jts.service.WFServiceInfo;
import com.newgen.omni.jts.timer.WFTimerServiceLocal;
import com.newgen.omni.jts.timer.WFTimerServiceLocalHome;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.util.xml.XMLParser;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;

import org.apache.commons.io.FilenameUtils;

public class MonitorServiceManager {

    private static XMLParser MonitorServiceConfig;
    private static final MonitorServiceManager instance = new MonitorServiceManager();
    private static boolean bMonitorServiceStarted;

    public static MonitorServiceManager getSharedInstance() {
        return instance;
    }

    private MonitorServiceManager() {
        String configLocation = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
        if (configLocation == null || configLocation.equals("")) {
            configLocation = System.getProperty("user.dir");
        }
        if (!configLocation.endsWith(File.separator)) {
            configLocation = configLocation + File.separator;
        }
        String configFilePath = configLocation + "wfsconfig" + File.separator + "MonitorService" + File.separator + "MonitorServiceConfig.xml";
        MonitorServiceConfig = new XMLParser(readFile(configFilePath));
    }

    public void startMonitorService(int serviceId) {
        try {
            if (serviceId == 0) {
                return;
            }
            //bMonitorServiceStarted = false;
            if (!bMonitorServiceStarted) {
                bMonitorServiceStarted = true;
                int MaxHibernateTime = Integer.valueOf(MonitorServiceConfig.getStringValueOf("MaxServiceHibernateTime", 0, Integer.MAX_VALUE, false, "3"));
                WFServiceInfo serviceInfo = new WFServiceInfo();
                serviceInfo.setEngineName("");
                serviceInfo.setServiceId(0);
                serviceInfo.setServiceName("OFSMonitor");
                serviceInfo.setServiceType("Monitor Service");
                serviceInfo.setDateFormat("");
                serviceInfo.setEnableLog(false);
                serviceInfo.setMonitorStatus(false);
                serviceInfo.setSleepTime(MaxHibernateTime * 30);
                serviceInfo.setOtherInfo("<MaxServiceHibernateTime>" + (MaxHibernateTime * 60) + "</MaxServiceHibernateTime>");
                serviceInfo.setApplicationId("OFSMonitor");
                serviceInfo.setPSIdentification("OFSMonitor");
                
                /*String lookUpName=WFSConstant.TIMER_SERVICE_LOOKUP_NAME;
                WFTimerServiceLocalHome obj = (WFTimerServiceLocalHome) getHomeObject(lookUpName,"");
                WFTimerServiceLocal  JTSTxn= (WFTimerServiceLocal) PortableRemoteObject.narrow(obj.create(), WFTimerServiceLocal.class);
                ServiceManagerClient.getReference().scheduleTimer(serviceInfo,JTSTxn); */
                ServiceManagerClient.getReference().scheduleTimer(serviceInfo);
            }
        } catch (Exception exc) {
            bMonitorServiceStarted = false;
            WFSUtil.printErr("", exc);
        }
    }

    private String readFile(String filePath) {
		FileInputStream fis=null;
        try {
        	filePath = FilenameUtils.normalize(filePath);
            File file = new File(filePath);
            StringBuilder fileBuilder = new StringBuilder();
            byte[] buff = new byte[1024];
             fis = new FileInputStream(file);
            int readSize;
            while ((readSize = fis.read(buff)) > 0) {
                fileBuilder.append(new String(buff, 0, readSize));
            }
            fis.close();
			fis=null;
            return fileBuilder.toString();
        } catch (IOException exc) {
            WFSUtil.printErr("", exc);
            return "";
        }finally{
			try{
				if(fis!=null){
					fis.close();
					fis=null;
				}
			}catch(Exception e){}
		}
    }
    
    private Object getHomeObject(String lookupName,String engine) {
        Context ctx = null;
        Object home = null;
        Object obj=null;

        lookupName = "java:comp/env/" + lookupName;

        try {
                ctx = new InitialContext();
                try {
                    home = ctx.lookup(lookupName);
                    ctx.close();
                    ctx = null;
                } catch (NamingException ne) {
                    WFSUtil.printErr(engine,"", ne);
                }
                obj = (WFTimerServiceLocalHome) PortableRemoteObject.narrow(home, WFTimerServiceLocalHome.class);

  
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
        } finally {
            try {
                if (ctx != null) {
                    ctx.close();
                    ctx = null;
                }
            } catch (Exception ignored) {
            }
        }
        return obj;
    }
}
