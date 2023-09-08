//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group						: Application Products 
//Product / Project			: JTS(EJB)
//Module					: Beans
//File Name					: WMActivityInstanceLocalHome.java	
//Author					: Harmeet Kaur
//Date written (DD/MM/YYYY)	: 09/12/2004
//Description				: It represents the Home Interface of the WMActivityInstance Bean.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.CreateException;
import javax.ejb.EJBLocalHome;
import com.newgen.omni.jts.txn.*;
import java.rmi.RemoteException;

public interface WMActivityInstanceLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
}