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
//13/10/2017	Mohnish Chopra	Bug 72577 - WAS+SQL:Unable to deploy wfs_ejb

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.local;

import javax.ejb.EJBException;
import javax.ejb.EJBLocalHome;
import javax.ejb.CreateException;

public interface WFDmsLocalHome extends EJBLocalHome {
    
    /*----------------------------------------------------------------------------------------------------
    Function Name                          : create
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : none
    Output Parameters                      : none
    Return Values                          : WFTransaction
    Description                            : returns the EJB object of WFCalendar bean. only a signature method
    ----------------------------------------------------------------------------------------------------
    */

    WFDmsLocal create() throws EJBException, CreateException;
}
