//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group						: Application Products 
//Product / Project			: JTS(EJB)
//Module					: Beans
//File Name					: WFSearchLocalHome.java	
//Author					: Ashish Mangla
//Date written (DD/MM/YYYY)	: 08/12/2004
//Description				: It represents the Home Interface of the WFSearch Bean.
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

public interface WFSearchLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
}