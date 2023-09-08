//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: Application Products 
//		Product / Project			: Omni Flow 6.1
//		Module						: Workflow Server
//		File Name					: WFCustomTransaction.java	
//		Author						: Mandeep Kaur
//		Date written (DD/MM/YYYY)	: 30/08/2005
//		Description					: Custom transaction home.
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
//
//-------------------------------------------------------------------------

package com.newgen.omni.jts.txn;

import java.sql.Connection;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.excp.*;
import java.rmi.RemoteException;
import javax.ejb.EJBLocalObject;

public interface WFCustomTransaction extends EJBLocalObject{

	public String execute(Connection connection, XMLParser parser, XMLGenerator generator) throws WFSException, JTSException;

}
