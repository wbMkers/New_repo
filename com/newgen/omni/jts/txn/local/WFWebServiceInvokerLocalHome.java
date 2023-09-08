/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFWebServiceInvokerHome.java
             Author				: Ruhi Hira
             Date written		: 26/12/2005
             Description		: Local Home interface for WFWebServiceInvoker bean.
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.txn.local;

import javax.ejb.*;

public interface WFWebServiceInvokerLocalHome extends EJBLocalHome{

    WFWebServiceInvoker create() throws EJBException, CreateException;

}
