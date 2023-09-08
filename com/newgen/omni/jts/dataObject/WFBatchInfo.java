//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFBatchInfo.java
//	Author						: Ashish Mangla
//	Date written (DD/MM/YYYY)	: 02/02/2006
//	Description					: for batching for keeping last value of the control
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

public class WFBatchInfo {
	public String columnName;
	public char orderBy;
	public String lastValue;

	public WFBatchInfo() {
	}

	public WFBatchInfo(String columnName, char orderBy, String lastValue) {
		this.columnName = columnName;
		this.orderBy = orderBy;
		this.lastValue = lastValue;
	}
}