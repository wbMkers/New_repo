//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 08/01/2008		Varun Bhansaly			Bugzilla Id 3284 
//											(Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar)
// 14/08/2008       Varun Bhansaly          SrNo-1, Float precision
//---------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.constt.WFSConstant;
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

public class WMAttribute {
  public int type;
  public String name;
  public String value;
  public int extObj;
  public char scope;
  public int length;
  public int precision;

  public WMAttribute(String name, String value, int type) {
    this.name = name;
    this.value = value;
    this.type = type;
  }

  public WMAttribute(String name, int extObj, int type,char scope) {
    this.name = name;
    this.extObj = extObj;
    this.type = type;
    this.scope = scope;
  }

  public WMAttribute(String name, String value, int type, int length){
	  this.name = name;
      this.value = value;
      this.type = type;
	  this.length = length;
  }
 
  public WMAttribute(String name, int extObj, int type,char scope, int length){
      this(name, extObj, type, scope, length, WFSConstant.CONST_FLOAT_PRECISION);
  }
  
  public WMAttribute(String name, int extObj, int type,char scope, int length, int precision) {
	  this.name = name;
      this.extObj = extObj;
      this.type = type;
      this.scope = scope;
	  this.length = length;
      this.precision = precision;
  }

  public WMAttribute() {}
};