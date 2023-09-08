//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group						: Application �Products 
//Product / Project			: JTS(EJB)
//Module					: Beans
//File Name					: WFDataLocalHome.java	
//Author					: Dinkar Kad
//Date written (DD/MM/YYYY)	: 18/18/2014
//Description				: It represents the Home Interface of the WFSearch Bean.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//	18/07/2014		Dinkar Kad		Bug 47492 - To provide IGGetData and IGSetData APIs in wfs_ejb.jar with the name WFSetData and WFGetData respectively.
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.CreateException;
import javax.ejb.EJBLocalHome;
import com.newgen.omni.jts.txn.*;
import java.rmi.RemoteException;

public interface WFDataLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
}