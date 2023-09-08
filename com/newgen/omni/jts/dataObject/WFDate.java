//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFDate.java
//	Author						: Ashish Mangla
//	Date written (DD/MM/YYYY)	: 10/03/2005
//	Description					: Executing external Application function....
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 11/04/2005	Ashsih Mangla	WFS_6_005
// 08/08/2007   Shilpi S        Bug # 1608      
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Locale;


public class WFDate implements java.io.Serializable{
	private Date value;

	public WFDate() {
    }

	public WFDate(Date value) {
		this.value = value;
    }

    public Date getValue() {
		return value;
    }

    public void setValue(Date value) {
		this.value = value;
    }

	public String toString() {
		if (value == null) {
			return "null";
		}else {
			//Bug # 1608
			return (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss" , Locale.US).format(value));	//Ashish changed for WFS_6_005
		}
	}
}