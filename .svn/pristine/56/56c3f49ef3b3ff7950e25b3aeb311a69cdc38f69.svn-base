/*----------------------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
                         Group : Phoenix
                       Product : OmniFlow
                        Module :
                     File Name : WFTimerServiceBean.java
                        Author : Abhishek Gupta
                  Date written : Feb 20, 2010
                   Description : Schedules and handles timer operations.
 -----------------------------------------------------------------------------------------
                            CHANGE HISTORY
 -----------------------------------------------------------------------------------------
 Date		    Change By	    Change Description (Bug No. If Any)
 19/05/2010     Abhishek Gupta  Bugzilla Bug 12830(Error in cancelling single timeout timer inside ejbTimeOut method).
 05/07/2012     Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 10/04/2013		Ashish Mangla	Bug 38939 only one utility at a time is running
 18/03/2014		Shweta Singhal	NGLogger implementation for WFServices logging
 09/01/2014		Mohnish Chopra	Bug 52099 - Click on postgres cabinet in OFservices, an error " Cabinet Connection Failed!!!." is generated (edit) 
 03/08/2015     Ashutosh Pandey Bug 56037 - Multiple Instance of utilities is running with same session
 02/09/2016     Sajid Khan      Bug 62455 - In OFServices if a utility thread gets stuck then user is not able to restart that utility[Merging]    
  17/12/2019  Sourabh Tantuway Bug 89137 - iBPS 3.0 SP2: To provide a framework which will monitor the utilities in Ofservices and  if any utility thread gets stuck it will restart it automatically.
 ---------------------------------------------------------------------------------------*/
package com.newgen.omni.jts.timer;

import com.newgen.omni.jts.cache.ServiceCollection;
import com.newgen.omni.jts.service.WFServiceInfo;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.app.ServiceFramework;
import com.newgen.omni.wf.util.app.constant.ApplicationConstants;
import com.newgen.omni.jts.util.MonitorServiceManager;
import com.newgen.omni.wf.util.app.exception.AppException;
import com.newgen.omni.wf.util.cache.WFServiceStatusCache;
import com.newgen.omni.wf.util.data.WFServiceStatus;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.xml.api.CreateXML;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;
import java.io.IOException;
import java.rmi.RemoteException;
import java.util.Collection;
import java.util.Iterator;
import javax.ejb.CreateException;
import javax.ejb.SessionBean;
import javax.ejb.SessionContext;
import javax.ejb.TimedObject;
import javax.ejb.Timer;
import javax.ejb.TimerService;
import javax.naming.NamingException;

/**
 *
 * @author abhishek_gupta
 */

public class WFTimerServiceBean implements SessionBean,TimedObject {

    private SessionContext ctx;

    public void setSessionContext(SessionContext sc) {
//        WFSUtil.printOut("TimerServiceBean: setSessionContext");
        ctx = sc;
	 }

    public void createTimer(WFServiceInfo svcInfo) throws Exception{
//        long millis = 0;
//        TimerService timerService = null;
//        setSessionContext(ctx);
//        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//        Date date = new Date();
//        WFSUtil.printOut("Timer created at time : " + dateFormat.format(date));
        ctx.getTimerService().createTimer(20, svcInfo);
    }

    public void ejbTimeout(Timer timer) {
        try{
//        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//        Date date = new Date();
//        WFSUtil.printOut("Inside timeout handler ::::::::: at time " + dateFormat.format(date));

        WFServiceInfo svcInfo = (WFServiceInfo) timer.getInfo();
        MonitorServiceManager.getSharedInstance().startMonitorService(svcInfo.getServiceId());
        ServiceFramework svc = null;
        boolean bStopUtility = false;
		char char21 = 21;
		String string21 = "" + char21;

        if(svcInfo != null) {
            svc = ServiceCollection.getReference().getService(svcInfo);
            if(svc != null && svc.getInitializeStatus()){
                

                /**
                 * This method would invoke system service by calling executeBusinessLogic method
                 *
                 */
                /**
                 * From ServiceCollection cache, get the instance of System servie
                 * cast it to ServiceFrameWorkx
                 */
                int appStatus = 0;
                int iPreviousCount = 0;
                boolean bCreateNewTimer = false;
//                if (svc != null) {
                    while (true) {
                        try {
                            //synchronized (this) {	//commented for Bug 38939

        //                WFSUtil.printOut("Calling ExecuteBusinessLogic()");
                        appStatus = svc.executeBusinessLogic();
        //                WFSUtil.printOut("Status returned :::::  " + iStatus);
                        /**
                         * call executeBusinessLogic  method on this
                         * until some error comes....
                         * in case of error break out of loop
                         */

/*
                        if (appStatus == 0) {     //  Workitem processed successfully.
                            continue;
                        } else if (appStatus == 2) {      //  No more workitems available. New timer required to wait for Sleeptime.
                            bCreateNewTimer = true;
                            break;
                        } else {    //  Timer needs to be cancelled. Utility stops in this case.
        //                    WFSUtil.printOut("Cancelling timer :::::::::::");
                            bStopUtility = true;
                            break;
                        }
*/
                            // } //Bug 38939
                            iPreviousCount = WFServiceStatusCache.getReference().getStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId()).getStatCount();
                        } catch (XMLParseException xep) {
                            svc.getRegInfo().getServiceLogger().printErr(xep);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_UNKNOWNFROMWFS, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (NGException ex) {
                            svc.getRegInfo().getServiceLogger().printErr(ex);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_IN_WFS_CONNECTION, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (NamingException ex) {
                            svc.getRegInfo().getServiceLogger().printErr(ex);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_IN_WFS_CONNECTION, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (RemoteException ex) {
                            svc.getRegInfo().getServiceLogger().printErr(ex);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_IN_WFS_CONNECTION, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (CreateException ex) {
                            svc.getRegInfo().getServiceLogger().printErr(ex);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_IN_WFS_CONNECTION, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (IOException e) {
                            svc.getRegInfo().getServiceLogger().printErr(e);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_IN_WFS_CONNECTION, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (AppException e) {
                            svc.getRegInfo().getServiceLogger().printErr(e);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(e.getErrorCode(), null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } /*catch (InterruptedException e) {
                            svc.getRegInfo().getServiceLogger().printErr(e);
                            appStatus = ApplicationConstants.APP_WAIT;

                        } */catch (Exception e) {
                            svc.getRegInfo().getServiceLogger().printErr(e);
                            WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.ERROR_UNKNOWNFROMWFS, null, String.valueOf(iPreviousCount)).toString());
                            appStatus = ApplicationConstants.APP_WAIT;

                        } catch (Throwable th) {
                            svc.getRegInfo().getServiceLogger().printErr(th);
                            appStatus = ApplicationConstants.APP_WAIT;
                        } //finally {
                            if (appStatus == ApplicationConstants.APP_WAIT){
                                bCreateNewTimer = true;
                                break;
                            } else if(appStatus == ApplicationConstants.APP_ERR){
                                bStopUtility = true;
                                break;
                            }
                        //}
                    }
//                }

                if (bCreateNewTimer) {
//                    timer.cancel();       //  Bugzilla Bug 12830
        //            Date date1 = new Date();
        //            WFSUtil.printOut("New Timer created at time : " + dateFormat.format(date1));
                    ctx.getTimerService().createTimer(svcInfo.getSleepTime() * 1000, svcInfo);
                }
            } else {
                WFSUtil.printOut(svcInfo.getEngineName(),"Error in Utility Initialization. Hence stopping utility.");
                bStopUtility = true;
            }
        } else {
                /**
                 * weird case
                 * discard the timer event.....
                 * also cancel this time event if possible
                 *
                 */
            WFSUtil.printOut(svcInfo.getEngineName(),"ServiceInfo Object found null. Hence stopping utility.");
            bStopUtility = true;
        }
        if(bStopUtility){
//            timer.cancel();           //  Bugzilla Bug 12830
           if(svcInfo != null && !svcInfo.isDuplicateInstance() && !ServiceCollection.getReference().isServiceRunning(svcInfo) && svcInfo.getServiceId() != 0) {
                WFSUtil.printOut(svcInfo.getEngineName(),"Removing service object for application : " + svcInfo.getServiceName());
                ServiceCollection.getReference().removeService(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), svcInfo.getEngineName());
                //  Setting utility status as stopped.
                int iPreviousCount = WFServiceStatusCache.getReference().getStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId()).getStatCount();
                WFServiceStatusCache.getReference().setStatusInfo(svcInfo.getEngineName() + string21 + svcInfo.getServiceId(), iPreviousCount, CreateXML.sendCSStatus(ApplicationConstants.STOPPED_APPLICATION, null, String.valueOf(iPreviousCount)).toString());
            }
        }



        /**
         * In case of no more workitems, the workitem count should be updated in the TimerStatus map.
         * or this should be removed on stop or start....
         */
        /**
         * In case of invalid session, this cached info should be removed??
         * or this should be removed on stop or start....
         */

        } catch(Exception e){
           // e.printStackTrace();
        	WFSUtil.printOut("","Exception in ejbtimeout"  + e);
        }
    }

    public void stopTimers() throws Exception {
       // WFSUtil.printOut("ExampleTimerBean[] stopTimer().. Cancelling all timers");
        TimerService ts = ctx.getTimerService();
        Collection timers = ts.getTimers();
        Iterator it = timers.iterator();
        while (it.hasNext()) {
            Timer timer = (Timer) it.next();
            if (timer.getInfo() != null) {
                WFSUtil.printOut("", "Timer cancelled for ServiceName : " + ((WFServiceInfo) timer.getInfo()).getServiceName());
            } else {
                WFSUtil.printOut("", "Timer Cancelled for Unknown ServiceName...");
            }
            timer.cancel();
        }
    }

    public String getStatusInfo(String engineName, String psId) {
		char char21 = 21;
		String string21 = "" + char21;
        WFServiceStatus info = WFServiceStatusCache.getReference().getStatusInfo(engineName + string21 + psId);
        int count = info.getStatCount();
        String statMessage = info.getStatDesc();
        return "<StatusInfo><StatCount>" + count + "</StatCount><StatMessage>" + statMessage + "</StatMessage></StatusInfo>";
    }

    public void stopTimer(WFServiceInfo svcInfo) throws Exception{
        WFSUtil.printOut(svcInfo.getEngineName(),"ExampleTimerBean[] stopTimer().. Cancelling timer");
        TimerService ts = ctx.getTimerService();
        Collection timers = ts.getTimers();
        Iterator it = timers.iterator();
        boolean bTimerCancelled = false;
        while (it.hasNext()) {
            Timer timer = (Timer) it.next();
            if (timer.getInfo() != null) {
                if((WFServiceInfo)timer.getInfo() == svcInfo){
                    WFSUtil.printOut("", "Timer cancelled for ServiceName : " + ((WFServiceInfo) timer.getInfo()).getServiceName());
                    bTimerCancelled = true;
                    timer.cancel();
                    break;
                }
            }
        }
        if(!bTimerCancelled)
            WFSUtil.printOut(svcInfo.getEngineName(),"Timer not found...............");
    }

     public void ejbCreate() {
        WFSUtil.printOut("", "TimerServiceBean: ejbCreate()");
     }

     public void ejbRemove() {}
     public void ejbActivate() {}
     public void ejbPassivate() {}
}
