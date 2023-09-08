//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group				: Application Products 
//Product / Project		: JTS
//Module				: EJB
//File Name				: NGOClientServiceHandler.java	
//Author				: Atam Govil
// Date written (DD/MM/YYYY): 28/03/02
//Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn;

import com.newgen.omni.jts.excp.*;
import java.rmi.RemoteException;
import javax.ejb.EJBObject;

public interface WFClientServiceHandler extends EJBObject
{
	public String execute(String strInputXML) throws RemoteException, JTSException;

} // end of interface NGOClientServiceHandler