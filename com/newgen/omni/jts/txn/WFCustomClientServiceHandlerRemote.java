//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: Application Products 
//		Product / Project			: Omni Flow 6.1
//		Module						: Workflow Server
//		File Name					: WFCustomClientServiceHandlerRemote.java	
//		Author						: Mandeep Kaur
//		Date written (DD/MM/YYYY)	: 30/08/2005
//		Description					: Remote for Custom service handler
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
//
//-------------------------------------------------------------------------

package com.newgen.omni.jts.txn;

import com.newgen.omni.jts.excp.*;
import java .rmi.RemoteException;
import javax.ejb.EJBObject;

public interface WFCustomClientServiceHandlerRemote extends EJBObject{

	public String execute(String strInputXML) throws RemoteException, JTSException;

} // end of interface WFCustomRemote