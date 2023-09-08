//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group				: Application Products 
//Product / Project		: JTS(EJB)
//Module				: Beans 	
//File Name				: Transaction.java	
//Author				: Atam Govil
// Date written (DD/MM/YYYY)	: 28/03/02
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

import java.sql.Connection;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.excp.*;
import java.rmi.RemoteException;
import javax.ejb.EJBLocalObject;

public interface WFTransaction extends EJBLocalObject{
    public String execute(Connection connection, XMLParser parser, XMLGenerator generator) throws WFSException,JTSException;
//	public void remove() throws Exception;
}//end-Transaction
