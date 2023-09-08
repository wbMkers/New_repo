/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
 * Date           Change By           Change Description (Bug No. If Any)
05/07/2012     Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
11/07/2014	   Mohnish Chopra	   Change for lookup of TimerServiceBean in Jboss EAP
08/08/2014	   Mohnish Chopra	   Bug 46509 Code review suggestion - Suggestion on iBPS TimerService Local/Remote lookup

--------------------------------------------------------------------------------
 ------------------------------------------------------------------------------*/

package com.newgen.omni.jts.service;

/*import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.jts.timer.WFTimerServiceHome;
import com.newgen.omni.jts.timer.WFTimerServiceRemote;*/
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import javax.naming.Context;
/*import javax.naming.InitialContext;
import javax.rmi.PortableRemoteObject;*/
import com.newgen.omni.jts.timer.WFTimerServiceLocal;
import com.newgen.omni.jts.timer.WFTimerServiceLocalHome;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;
/**
 *
 * @author abhishek_gupta
 */
public class ServiceManagerClient{

    private static ServiceManagerClient Client = new ServiceManagerClient();
/*    private WFTimerServiceRemote remote = null;    //  Variable taken static. Check.
*/    public static ServiceManagerClient getReference(){
        return Client;
    }

 /*  public void scheduleTimer(WFServiceInfo serviceInfo) throws Exception{
        Context ctx = null;
        Object obj = null;
        try{
            StringBuffer timerBeanLookUpName = new StringBuffer();
            ctx = WFFindClass.getReference().getExtAppContext("TimerServiceBean");
            timerBeanLookUpName.append(WFServerProperty.getSharedInstance().getTimerServiceLookUpData().getProperty(WFSConstant.CONST_TIMER_SERVICE_LOOKUP_PREFIX));
            timerBeanLookUpName.append("TimerServiceBean");
            timerBeanLookUpName.append(WFServerProperty.getSharedInstance().getTimerServiceLookUpData().getProperty(WFSConstant.CONST_TIMER_SERVICE_LOOKUP_SUFFIX));
            //  Lookup for EJB 2.1  Starts here     Used when Ejb 2.1 is deployed.
            obj=ctx.lookup(timerBeanLookUpName.toString());
            WFTimerServiceHome home=(WFTimerServiceHome)PortableRemoteObject.narrow(obj,WFTimerServiceHome.class);
            remote = home.create();
            //  Lookup for EJB 2.1  Ends here
        } catch(Exception ex){
            WFSUtil.printErr(serviceInfo.getEngineName(),"", ex);
            try{
                //  Lookup for EJB 3.0  Starts here    Used when Ejb 3.0 is deployed.
                obj = ctx.lookup("TimerServiceBean/remote");
                remote = (WFTimerServiceRemote)obj;
                //  Lookup for EJB 3.0  Ends here
            } catch(Exception ex1) {
                WFSUtil.printErr(serviceInfo.getEngineName(),"", ex1);
            }
        }
		remote.createTimer(serviceInfo);
   }*/

/**
 * *************************************************************
 * Function Name    :   scheduleTimer
 * Programmer' Name :   Mohnish Chopra
 * Date Written     :   08/08/2014
 * Input Parameters :   WFServiceInfo serviceInfo,WFTimerServiceLocal local
 * Description      :   Calls createTimer on local timer service bean
 * *************************************************************
 */
   public void scheduleTimer(WFServiceInfo serviceInfo,WFTimerServiceLocal local) throws Exception{
       try{
    	   local.createTimer(serviceInfo);
       } catch(Exception ex){
           WFSUtil.printErr(serviceInfo.getEngineName(),"", ex);
       }
    }
   
     public void scheduleTimer(WFServiceInfo serviceInfo) throws Exception{
       String strCabinetName = "";  
       try{
           strCabinetName = serviceInfo.getEngineName();
    	   String lookUpName=WFSConstant.TIMER_SERVICE_LOOKUP_NAME;
           WFTimerServiceLocalHome obj = (WFTimerServiceLocalHome) getHomeObject(lookUpName,strCabinetName);
           if(obj!=null){
        	   WFTimerServiceLocal  JTSTxn= (WFTimerServiceLocal) PortableRemoteObject.narrow(obj.create(), WFTimerServiceLocal.class);
        	   scheduleTimer(serviceInfo, JTSTxn); 
           }else{
        	   throw new Exception("ServiceManageClient-WFtimerServiceLocalHome obj is null");
           }
             
       } catch(Exception ex){
           WFSUtil.printErr(serviceInfo.getEngineName(),"", ex);
         
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
