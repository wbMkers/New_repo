package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.CreateException;
import com.newgen.omni.jts.txn.*;

public interface WFProcessRegistrationLocalHome extends WFTransactionHome
{
	WFTransaction create() throws EJBException,CreateException;
}