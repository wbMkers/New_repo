/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFWSReqMDB.java
             Author				: Ruhi Hira
             Date written		: 26/12/2005
             Description		: Bean to handle response in case of
                                    asynchronous invocation [MDB].
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)
 13/01/2006     Ruhi Hira       Bug # WFS_6.1.2_010.
 19/10/2007		Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
								System.err.println() & printStackTrace() for logging.
 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.mdb;

import javax.ejb.*;
import javax.jms.*;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.constant.NGConstant;
import com.newgen.omni.jts.txn.local.*;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.util.WFWebServiceUtil;
import com.newgen.omni.jts.srvr.DatabaseTransactionServer;
import com.newgen.omni.jts.util.WFSUtil;

public class WFWSReqMDB implements MessageDrivenBean, MessageListener {

    private MessageDrivenContext m_context; /* at present not in use */

    /**
     * *******************************************************************************
     *      Function Name       : onMessage
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : Message - JMSMessage.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : MessageListener, invoked when message comes in JMS
     *                              destination [WFWSReqQueue].
     * *******************************************************************************
     */
    /* Bug # WFS_6.1.2_010, Exception handling + debug - Ruhi Hira */
    public void onMessage(Message msg) {
        String input = null;
        String response = null;
        String engineName = null;
        try {
            if (msg instanceof TextMessage) {
                input = ((TextMessage) msg).getText();
            } else {
                WFSUtil.printOut(""," [WFWSReqMDB] msg is not an instanceof TextMessage");
                return;
            }
            XMLParser parser = new XMLParser(input);
            engineName = parser.getValueOf(WFWebServiceUtil.PROP_ENGINENAME);
            WFWebServiceInvoker ejbObject = (WFWebServiceInvoker) NGEjbClient.getSharedInstance().
                lookUpEJBObject( null, NGConstant.APP_WORKFLOW,
                                 WFFindClass.getLookUpNameForTxn("WFInvokeWebService", engineName),
                                 "com.newgen.omni.jts.txn.local.WFWebServiceInvokerLocalHome",
                                 "com.newgen.omni.jts.txn.local.WFWebServiceInvoker",
                                 "L"); /* for local lookup */
            /**
             * Ignoring response as handled in WFWebServiceUtil.....
             * This is jus for writing in XML log.
             * - Ruhi Hira
             */
            response = ejbObject.execute(input);
        } catch (Exception ex) {
            /**
             * NOTE: if some exception comes here, workitem will stay on JMSSubscribe workstep
             * that following web service workstep and can exit only after expiry. - Ruhi Hira
             */
            WFSUtil.printOut(engineName," [WFWSReqMDB] onMessage ...... Exception while handling message in WFWSReqQueue " + ex.getMessage());
            WFSUtil.printErr(engineName,"", ex);
        } finally {
            try{
				WFSUtil.writeLog(input, response);
            } catch(Exception ignored){
                WFSUtil.printOut(engineName," [WFWSReqMDB] onMessage .... Ignoring exception : " + ignored.getMessage());
            }
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : setMessageDrivenContext
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : MessageDrivenContext.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method defined in MessageDrivenBean.
     * *******************************************************************************
     */
    public void setMessageDrivenContext(MessageDrivenContext messageDrivenContext) throws EJBException {
        m_context = messageDrivenContext;
    }

    /**
     * *******************************************************************************
     *      Function Name       : ejbCreate
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : ??
     * *******************************************************************************
     */
    public void ejbCreate() {
    }

    /**
     * *******************************************************************************
     *      Function Name       : ejbRemove
     *      Date Written        : 26/12/2005
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Method defined in MessageDrivenBean.
     * *******************************************************************************
     */
    public void ejbRemove() throws EJBException {
    }

}
