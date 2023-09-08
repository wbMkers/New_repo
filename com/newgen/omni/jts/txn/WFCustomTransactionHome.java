//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: Application Products 
//		Product / Project			: Omni Flow 6.1
//		Module						: Workflow Server
//		File Name					: WFCustomTransactionHome.java	
//		Author						: Mandeep Kaur
//		Date written (DD/MM/YYYY)	: 30/08/2005
//		Description					: Custom Trsanction home class.
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
//
//-------------------------------------------------------------------------

package com.newgen.omni.jts.txn;

import com.newgen.omni.jts.txn.WFCustomTransaction;
import javax.ejb.EJBException;
import javax.ejb.CreateException;
import javax.ejb.EJBLocalHome;

public interface WFCustomTransactionHome extends EJBLocalHome{

	WFCustomTransaction create() throws EJBException,CreateException;

}
