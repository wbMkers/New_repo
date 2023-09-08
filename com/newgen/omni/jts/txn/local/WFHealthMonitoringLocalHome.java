
package com.newgen.omni.jts.txn.local;

import javax.ejb.CreateException;
import javax.ejb.EJBException;


import com.newgen.omni.jts.txn.WFTransaction;
import com.newgen.omni.jts.txn.WFTransactionHome;

public interface WFHealthMonitoringLocalHome extends WFTransactionHome{
	
	WFTransaction create() throws EJBException,CreateException;

}
