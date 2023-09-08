//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group				: Application �Products 
//Product / Project		: Omniflow 8.1
//Module				: Transport Management System
//File Name				: WFTransportLocalHome.java
//Author				: Saurabh Kamal
// Date written (DD/MM/YYYY): 05/02/2010
//Description				:It represents the Home Interface of the WFTransport Bean.
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

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.CreateException;
import javax.ejb.EJBLocalHome;
import com.newgen.omni.jts.txn.*;
import java.rmi.RemoteException;

public interface WFTransportLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
//	public void remove() throws RemoteException;
}

