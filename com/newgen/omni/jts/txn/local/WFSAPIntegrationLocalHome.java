//----------------------------------------------------------------------------------------------------
//      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Phoenix
//  Product / Project           : OmniFlow SAP Integration
//  Module                      : OmniFlow Server
//  File Name                   : WFSAPIntegrationLocalHome.java
//  Author                      : Ananta Handoo
//  Date written (DD/MM/YYYY)   : 18/03/2009
//  Description                 : local home for WFSAPIntegration bean
//----------------------------------------------------------------------------------------------------
//          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                     Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.local;

import javax.ejb.*;

public interface WFSAPIntegrationLocalHome extends EJBLocalHome {
   
	WFSAPIntegration create() throws EJBException,CreateException;
}

