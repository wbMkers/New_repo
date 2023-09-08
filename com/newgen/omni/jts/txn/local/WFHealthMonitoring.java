package com.newgen.omni.jts.txn.local;

import com.newgen.omni.jts.cmgr.*;
import javax.ejb.EJBLocalObject;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.WFSException;
import java.sql.*;


public interface WFHealthMonitoring extends EJBLocalObject{
	
	public String executeTranactionFree(XMLParser parser) throws WFSException, JTSException ;

}
