/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFWSResMDB.java
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
import com.newgen.omni.jts.util.WFSUtil;

public class WFWSResMDB implements MessageDrivenBean, MessageListener {

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
     *                              destination [WFWSResQueue].
     * *******************************************************************************
     */
    /* Bug # WFS_6.1.2_010, Exception handling + debug - Ruhi Hira */
    public void onMessage(Message msg) {
        String engineName = null;
        try{
            WFSUtil.printOut("", "[WFWSResMDB] onMessage ... ");
            String input = null;
            if (msg instanceof TextMessage) {
                input = ((TextMessage) msg).getText();
            } else {
                WFSUtil.printOut(""," [WFWSResMDB] onMessage ... msg is instanceof TextMessage");
                return;
            }
            engineName = input.substring(input.indexOf("<EngineName>") + 12,
                                                input.indexOf("</EngineName>") );
            boolean status = WFSUtil.insertInWFJMSMessageTable(input, "WFWSResQueue", engineName);
            if(!status){
                WFSUtil.printOut(engineName," [WFWSResMDB] onMessage ... Operation failed : insertion in WFJMSMessageTable ... ");
            }
            WFSUtil.printOut(engineName," [WFWSResMDB] onMessage completed and message successfully inserted in WFJMSMessageTable ... ");
        } catch(Exception ex){
            WFSUtil.printOut(engineName," [WFWSResMDB] onMessage ... Exception while processing response message : " + ex);
            WFSUtil.printErr(engineName,"", ex);
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
     *      Description         : Required acc to J2EE specifiation.
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
