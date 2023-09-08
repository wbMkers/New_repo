//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFToolAgent.java	
//	Author					: Prashant
//	Date written(DD/MM/YYYY): 16/05/2002
//	Description				: Interface definition to be implemented by all Tool Agents .
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.toolagents;

import java.util.Vector;

public interface WFToolAgent {

  int RUNNING = 2;
  int ACTIVE = 1;
  int WAITING = 3;
  int TERMINATED = 4;
  int FINISHED = 5;

  public abstract int WMTAConnect(String TAName, String username, String password);

  public abstract int WMTADisConnect(int TA_handle);

  public abstract int WMTAInvokeApplication(int TA_handle, String app_name, String processInst,
    int workItem, Vector attributeList, int appmode);

  public abstract int WMTARequestAppStatus(int TA_handle, String processInst, int workItem);

  public abstract int WMTATerminateApp(int TA_handle, String processInst, int workItem);

} //end-Transaction
