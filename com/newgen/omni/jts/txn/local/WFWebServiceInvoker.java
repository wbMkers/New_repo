/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFWebServiceInvoker.java
             Author				: Ruhi Hira
             Date written		: 26/12/2005
             Description		: LocalObject interface for WFWebServiceInvoker
                                    bean.
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBLocalObject;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSException;

public interface WFWebServiceInvoker extends EJBLocalObject{

    public String execute(String inputXML) throws WFSException, JTSException ;

}
