//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: Application Products 
//		Product / Project			: iBPS
//		Module						: iBPS Server
//		File Name					: WFTimerServiceLocal.java	
//		Author						: Mohnish Chopra
//		Date written (DD/MM/YYYY)	: 11/08/2014
//		Description					: Timer Service Local.As bean for TimerService and client will 
//  									always run in same JVM, hence local lookup is required 
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
//
//-------------------------------------------------------------------------

package com.newgen.omni.jts.timer;

import com.newgen.omni.jts.service.WFServiceInfo;

import javax.ejb.EJBLocalObject;
import javax.ejb.SessionContext;
import javax.ejb.Timer;

public interface WFTimerServiceLocal extends EJBLocalObject{
	
    public void setSessionContext(SessionContext sc) ;
    public void createTimer(WFServiceInfo svcInfo) throws Exception;
    public void ejbTimeout(Timer timer) ;
    public void stopTimers() throws Exception;
    public void stopTimer(WFServiceInfo svcInfo) throws Exception;
    public String getStatusInfo(String engineName, String psId) ;
	public void ejbCreate() ;

}
