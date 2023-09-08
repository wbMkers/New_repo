//----------------------------------------------------------------------------------------------------
//      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Phoenix
//  Product / Project           : OmniFlow
//  Module                      : OmniFlow Server
//  File Name                   : WFCalendarLocalHome.java
//  Author                      : Ahsan Javed
//  Date written (DD/MM/YYYY)   : 01/02/2007
//  Description                 : local home for WFCalendar bean
//----------------------------------------------------------------------------------------------------
//          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                     Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 16/01/2013		Shweta Singhal		Bug 37748, OfServices not working
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.CreateException;
import com.newgen.omni.jts.txn.*;
import com.newgen.omni.jts.txn.WFTimerTransactionHome;

public interface WFServiceManagerLocalHome extends WFTimerTransactionHome {

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : create
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : none
    Output Parameters                      : none
    Return Values                          : WFTimerTransaction
    Description                            : returns the EJB object of WFCalendar bean. only a signature method
    ----------------------------------------------------------------------------------------------------
    */

    WFTimerTransaction create() throws EJBException, CreateException;
}
