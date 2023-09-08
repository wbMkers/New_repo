/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Phoenix
             Product / Project	: OmniFlow v 8.0
             Module				: Omniflow Server
             File Name			: WFSAPIntegration.java
             Author				: Ananta Handoo.
             Date written		: 15\03\2009
             Description		: LocalObject interface for WFSAPIntegration
                                    bean.
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.txn.local;
import com.newgen.omni.jts.cmgr.*;
import javax.ejb.EJBLocalObject;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSException;
import java.sql.*;

public interface WFSAPIntegration extends EJBLocalObject {
	/*public String execute(Connection con,XMLParser parser,XMLGenerator gen) throws WFSException, JTSException ;*/
	public String executeTranactionFree(XMLParser parser) throws WFSException, JTSException ;
}
