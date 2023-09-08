/*----------------------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
                         Group : Phoenix
                       Product : OmniFlow
                        Module : 
                     File Name : WFServiceMaster.java
                        Author : amangla
                  Date written : Sep 7, 2009
                   Description : 
 -----------------------------------------------------------------------------------------
                            CHANGE HISTORY
 -----------------------------------------------------------------------------------------
 Date		    Change By	    Change Description (Bug No. If Any)
 30/09/2013     Kahkeshan       Code Merged for Custom Utility
 11/02/2014		Anwar Danish	New Services BusinessRuleExecutor added
 17 Nov 2015	Sajid Khan		Hold Workstep Enhancement.	
 10/03/2017     Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.
 11/08/2017 	 Mohnish Chopra	Changes for Case Summary document generation requirement
 12/12/2017		Sajid Khan		Bug 73913 - Rest Ful webservices implementation in iBPS 
 20/03/2019		Mohnish Chopra	Bug 84022 - Utility is required to migrate External and complex data on the basis of SecondaryDBFlag
 20/12/2019		Ambuj Tripathi	Changes for DataExchange Functionality
 ---------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.service;

import com.newgen.omni.jts.constt.WFSConstant;
import java.util.HashMap;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Properties;

import org.apache.commons.io.FilenameUtils;


public class WFServiceMaster {
	private static WFServiceMaster wfServiceMaster = new WFServiceMaster();
	
	private static HashMap<String, ServiceData> serviceMap = new HashMap<String, ServiceData>();
	private static ServiceData serviceData = null;
	
	private WFServiceMaster(){
		
	}
	public static WFServiceMaster getReference(){
		return wfServiceMaster;
	}
	
	static {
		serviceData = new ServiceData(1, WFSConstant.CONST_PROCESSSERVER, "com.newgen.omni.wf.ps.ProcessServer");
		serviceMap.put(WFSConstant.CONST_PROCESSSERVER, serviceData);
		serviceData = new ServiceData(2, WFSConstant.CONST_MAILUTILITY, "com.newgen.omni.wf.notifymail.MailingUtility");
		serviceMap.put(WFSConstant.CONST_MAILUTILITY, serviceData);
		serviceData = new ServiceData(3, WFSConstant.CONST_MESSAGENT, "com.newgen.omni.wf.messageagent.MessageAgent");
		serviceMap.put(WFSConstant.CONST_MESSAGENT, serviceData);
		serviceData = new ServiceData(4, WFSConstant.CONST_MAILAGENT, "com.newgen.omni.wf.mailagent.MailAgent");
		serviceMap.put(WFSConstant.CONST_MAILAGENT, serviceData);
		serviceData = new ServiceData(5, WFSConstant.CONST_PRINTFAXMAIL, "com.newgen.omni.wf.printfaxemail.PFEProcessor");
		serviceMap.put(WFSConstant.CONST_PRINTFAXMAIL, serviceData);
		serviceData = new ServiceData(6, WFSConstant.CONST_ARCHIVE, "com.newgen.omni.wf.archive.ArchiveUtility");
		serviceMap.put(WFSConstant.CONST_ARCHIVE, serviceData);
		serviceData = new ServiceData(7, WFSConstant.CONST_EXPORTUTIL, "com.newgen.omni.wf.exportutil.ExportUtil");
		serviceMap.put(WFSConstant.CONST_EXPORTUTIL, serviceData);
		serviceData = new ServiceData(8, WFSConstant.CONST_WSINVOKER, "com.newgen.omni.wf.ws.WSInvokerUtility");
		serviceMap.put(WFSConstant.CONST_WSINVOKER, serviceData);
		serviceData = new ServiceData(9, WFSConstant.CONST_PUBLISHER, "com.newgen.omni.wf.JMSPublish.JMSPublisher");
		serviceMap.put(WFSConstant.CONST_PUBLISHER, serviceData);
		serviceData = new ServiceData(10, WFSConstant.CONST_SUBSCRIBER, "com.newgen.omni.wf.JMSSubscribe.JMSSubscriber");
		serviceMap.put(WFSConstant.CONST_SUBSCRIBER, serviceData);
		serviceData = new ServiceData(11, WFSConstant.CONST_INITIATE, "com.newgen.omni.wf.initiation.InitiationUtility");      //  ServiceName taken temporarily.  Abhishek.
		serviceMap.put(WFSConstant.CONST_INITIATE, serviceData);
		serviceData = new ServiceData(12, WFSConstant.CONST_SAPINVOKER, "com.newgen.omni.wf.sap.SAPInvokerUtility");
		serviceMap.put(WFSConstant.CONST_SAPINVOKER, serviceData);
		serviceData = new ServiceData(13, WFSConstant.CONST_EXPORTPURGE, "com.newgen.omni.wf.export.ExportPurgeUtility");
		serviceMap.put(WFSConstant.CONST_EXPORTPURGE, serviceData);
		serviceData = new ServiceData(14, WFSConstant.CONST_IMPORT, "com.newgen.omni.wf.importutility.WFImportUtility");
		serviceMap.put(WFSConstant.CONST_IMPORT, serviceData);
		serviceData = new ServiceData(15, WFSConstant.CONST_UPLOAD, "com.newgen.omni.wf.fileuploader.WFFileUploadAgent");
		serviceMap.put(WFSConstant.CONST_UPLOAD, serviceData);
		serviceData = new ServiceData(16, WFSConstant.CONST_EXPIRY, "com.newgen.omni.wf.expiry.ExpiryThread");
		serviceMap.put(WFSConstant.CONST_EXPIRY, serviceData);
		serviceData = new ServiceData(17, WFSConstant.CONST_LOADBALANCER, "com.newgen.omni.wf.loadbalancer.LoadBalancer");
		serviceMap.put(WFSConstant.CONST_LOADBALANCER, serviceData);
		serviceData = new ServiceData(18, WFSConstant.CONST_SHAREPOINT, "com.newgen.omni.wf.archive.ArchiveUtility");
		serviceMap.put(WFSConstant.CONST_SHAREPOINT, serviceData);
		serviceData = new ServiceData(19, WFSConstant.CONST_BRMSINVOKER, "com.newgen.omni.wf.brms.BusinessRuleExecutor");		
		serviceMap.put(WFSConstant.CONST_BRMSINVOKER, serviceData);
                serviceData = new ServiceData(20, WFSConstant.CONST_REMINDER, "com.newgen.omni.wf.reminder.ReminderThread");		
		serviceMap.put(WFSConstant.CONST_REMINDER, serviceData);
		serviceData = new ServiceData(21, WFSConstant.CONST_OMSADAPTER, "com.newgen.omni.wf.oms.omsutility.WFOMSAdapterService");		
		serviceMap.put(WFSConstant.CONST_OMSADAPTER, serviceData);
                serviceData = new ServiceData(22, WFSConstant.CONST_AUDITARCHIVE, "com.newgen.omni.wf.auditTrail.AuditTrailUtility");		
		serviceMap.put(WFSConstant.CONST_AUDITARCHIVE, serviceData);
		serviceData = new ServiceData(23, WFSConstant.CONST_CASESUMMARY, "com.newgen.omni.wf.casedoc.WFCaseSummaryThread");		
		serviceMap.put(WFSConstant.CONST_CASESUMMARY, serviceData);
        serviceData = new ServiceData(24, WFSConstant.CONST_RESTSERVICE, "com.newgen.omni.wf.rest.RestServiceExecutor");		
        serviceMap.put(WFSConstant.CONST_RESTSERVICE, serviceData);
		serviceData = new ServiceData(25, WFSConstant.CONST_SECONDARYDATAMIGRATION, "com.newgen.omni.wf.secondarydatamigration.SecondaryDataMigrationThread");		
		serviceMap.put(WFSConstant.CONST_SECONDARYDATAMIGRATION, serviceData);
		serviceData = new ServiceData(26, WFSConstant.CONST_DATA_EXCHANGE, "com.newgen.omni.wf.dx.WFDataExchangeUtility");
		serviceMap.put(WFSConstant.CONST_DATA_EXCHANGE, serviceData);
		
		loadCustomFile();
	}

	public static void loadCustomFile(){
            String propFileName=WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + System.getProperty("file.separator")+"custom.ini";
            try{
                int i=19;
                Properties prop = new Properties();
                prop.load(new FileInputStream(FilenameUtils.normalize(propFileName)));
                Enumeration e=prop.propertyNames();
                while(e.hasMoreElements()){
                    String key=(String)e.nextElement();
                    serviceData = new ServiceData(i, prop.getProperty(key), "com.newgen.omni.wf."+key.toLowerCase()+"."+key);
                    serviceMap.put(prop.getProperty(key), serviceData);
                    i++;
                }
            }catch(Exception ex){
                //WFSUtil.printErr(Level.DEBUG, "", ex);
            }
        }
	public String getMainClass(String serviceType){
		String mainClass = null;
		ServiceData svcData = serviceMap.get(serviceType);
		if (svcData != null){
			mainClass = svcData.getMainClassName();
		}
		return mainClass;
	}
}

class ServiceData{
	private int serviceType;
	private String ServiceName;
	private String mainClassName;
	
	public ServiceData(){
	}
	
	public ServiceData(int serviceType, String ServiceName, String mainClassName){
		this.serviceType = serviceType;
		this.ServiceName = ServiceName;
		this.mainClassName = mainClassName;
	}

	public int getServiceType() {
		return serviceType;
	}

	public String getServiceName() {
		return ServiceName;
	}

	public String getMainClassName() {
		return mainClassName;
	}

	public void setMainClassName(String mainClassName) {
		this.mainClassName = mainClassName;
	}
}
