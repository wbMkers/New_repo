//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFLong.java
//	Author						: Ashish Mangla
//	Date written (DD/MM/YYYY)	: 10/03/2005
//	Description					: Executing external Application function....
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;


public class WFLong implements java.io.Serializable{
	private int value;

	public WFLong() {
    }

	public WFLong(int value) {
		this.value = value;
    }

    public int getValue() {
		return value;
    }

    public void setValue(int value) {
		this.value = value;
    }

	public String toString() {
		return String.valueOf(value);
	}
}