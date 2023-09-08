// ----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project	: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFTriggerInterface.java	
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 24/09/2002
//	Description			:
// ----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// ----------------------------------------------------------------------------------------------------
//
//
//
// ----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.triggers;

import java.sql.Connection;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;

public interface WFTriggerInterface {
  public String getTriggerData(Connection con, XMLGenerator gen,
    int processDefId, int dbType, int trigger);

  public int executeTrigger(Connection con, XMLParser parser, int dbType,
    int processDefId, int trigger, int activityId, String processInst,
    int workItem, int userID);
} // class WFTriggerInterface