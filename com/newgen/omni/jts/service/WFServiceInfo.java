/*----------------------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
                         Group : Phoenix
                       Product : OmniFlow
                        Module : 
                     File Name : WFServiceInfo.java
                        Author : amangla
                  Date written : Sep 7, 2009
                   Description : 
 -----------------------------------------------------------------------------------------
                            CHANGE HISTORY
 -----------------------------------------------------------------------------------------
 Date		    Change By	    Change Description (Bug No. If Any)
 05/07/2012         Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 022/01/2016         Anwar Danish        Multiple Instance of utilities is running with same session
 11/08/2017 		  Mohnish Chopra	Changes for Case Summary document generation requirement
 ---------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.service;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.wf.util.xml.XMLParser;
import com.newgen.omni.jts.util.WFSUtil;
import java.io.Serializable;

public class WFServiceInfo implements Serializable{
	private String engineName;
	private int serviceId;
	private String serviceName;
	private String serviceType;
	private int processdefid;
	private int sleepTime;
	private boolean enableLog;
	private boolean monitorStatus;
	private String charSet;
	private String dateFormat;
	private String otherInfo;
    private String applicationId;
    private String psIdentification;
    private String sessionId;
    private boolean duplicateInstance;
    
	private int genericServiceId;
 	public int getServiceId() {
		return serviceId;
	}

	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getServiceType() {
		return serviceType;
	}

	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}

	public int getProcessdefid() {
		return processdefid;
	}

	public void setProcessdefid(int processdefid) {
		this.processdefid = processdefid;
	}

	public int getSleepTime() {
		return sleepTime;
	}

	public void setSleepTime(int sleepTime) {
		this.sleepTime = sleepTime;
	}

	public boolean getEnableLog() {
		return enableLog;
	}

	public void setEnableLog(boolean enableLog) {
		this.enableLog = enableLog;
	}

	public boolean getMonitorStatus() {
		return monitorStatus;
	}

	public void setMonitorStatus(boolean monitorStatus) {
		this.monitorStatus = monitorStatus;
	}

	public String getCharSet() {
		return charSet;
	}

	public void setCharSet(String charSet) {
		this.charSet = charSet;
	}

	public String getDateFormat() {
		return dateFormat;
	}

	public void setDateFormat(String dateFormat) {
		this.dateFormat = dateFormat;
	}

	public String getOtherInfo() {
		return otherInfo;
	}

	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	public String getEngineName() {
		return engineName;
	}

	public void setEngineName(String strEngineName) {
		this.engineName = strEngineName;
	}

	public String getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(String strApplicationId) {
		this.applicationId = strApplicationId;
	}

	public String getPSIdentification() {
		return psIdentification;
	}

	public void setPSIdentification(String strPSIdentification) {
		this.psIdentification = strPSIdentification;
	}
	
    public XMLParser getParser(){
        XMLParser parser = new XMLParser();
        XMLGenerator gen = new XMLGenerator();
        StringBuffer strReturn = new StringBuffer();
        strReturn.append("<UtilityRegistrationInfo>");
        strReturn.append(gen.writeValueOf("RunAsTimerService", String.valueOf(true)));
        strReturn.append(gen.writeValueOf("PSID", String.valueOf(this.getServiceId())));
        strReturn.append(gen.writeValueOf("ApplicationName", String.valueOf(this.getServiceName())));
        strReturn.append(gen.writeValueOf("ApplicationType", String.valueOf(this.getServiceType())));
        strReturn.append(gen.writeValueOf("EnableLog", String.valueOf(this.getEnableLog())));
        strReturn.append(gen.writeValueOf("MonitorStatus", String.valueOf(this.getMonitorStatus())));
        strReturn.append(gen.writeValueOf("SleepTime", String.valueOf(this.getSleepTime())));
        strReturn.append(gen.writeValueOf("DateFormat", String.valueOf(this.getDateFormat())));
        if(this.otherInfo != null)
            strReturn.append(this.getOtherInfo());  //  Utility specific information.
        strReturn.append(gen.writeValueOf("EngineName", String.valueOf(this.getEngineName())));      //  Added Abhishek.
        strReturn.append(gen.writeValueOf("ApplicationID", String.valueOf(this.getApplicationId())));      //  Added Abhishek.
        strReturn.append(gen.writeValueOf("PSIdentification", String.valueOf(this.getPSIdentification())));      //  Added Abhishek.
        strReturn.append(gen.writeValueOf("CSName", "TempCSName"));      //  Added temporarily. Abhishek.
        strReturn.append("</UtilityRegistrationInfo>");
        parser.setInput(strReturn.toString());
        WFSUtil.printOut(engineName, "[WFServiceInfo] getParser() : XML Created : " + strReturn.toString());
        return parser;
    }

    /**
     * @return the sessionId
     */
    public String getSessionId() {
        return sessionId;
    }

    /**
     * @param sessionId the sessionId to set
     */
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    /**
     * @return the duplicateInstance
     */
    public boolean isDuplicateInstance() {
        return duplicateInstance;
    }

    /**
     * @param duplicateInstance the duplicateInstance to set
     */
    public void setDuplicateInstance(boolean duplicateInstance) {
        this.duplicateInstance = duplicateInstance;
    }

    public int getGenericServiceId() {
		return genericServiceId;
	}

	public void setGenericServiceId(int genericServiceId) {
		this.genericServiceId = genericServiceId;
	}

	
}