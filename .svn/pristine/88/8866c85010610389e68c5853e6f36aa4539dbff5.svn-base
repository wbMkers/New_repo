/*******************************************************************************
 *        NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 *    Product         : OmniFlow
 *    Module          : Transaction Server
 *    File            : WFServicesDataLocalHome.java
 *    Description     : Local Home for WFServicesData
 *    Classes         : 
 *    Functions       : 
 *    Written By      : Ashutosh Pandey
 *    Date written    : Feb 25, 2015
 *
 *    Change History  :
 *    Date          Change By               Change Description (Bug No. If Any)
 *    17/02/2015    Anju Gupta              Bug 53764  Optimization at CS, ofservices and utility end to reduce the user level configuration and usage of single system utility user to perform each user level operation
 ******************************************************************************/
package com.newgen.omni.jts.txn.local;

import com.newgen.omni.jts.txn.WFTransaction;
import com.newgen.omni.jts.txn.WFTransactionHome;
import javax.ejb.CreateException;
import javax.ejb.EJBException;

public interface WFServicesDataLocalHome extends WFTransactionHome {

    WFTransaction create() throws EJBException, CreateException;
}
