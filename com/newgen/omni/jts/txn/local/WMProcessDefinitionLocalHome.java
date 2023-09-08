//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group				: Application Products 
//Product / Project		: JTS(EJB)
//Module				: Beans
//File Name				: NGOCabinetHome.java	
//Author				: Sarathy 
// Date written (DD/MM/YYYY): 29/03/02
//Description				:It represents the Home Interface of the CabinetBean.
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

public interface WMProcessDefinitionLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
//	public void remove() throws RemoteException;
}

