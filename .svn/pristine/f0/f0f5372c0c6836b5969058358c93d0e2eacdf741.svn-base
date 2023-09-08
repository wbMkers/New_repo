/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFVariableMapping.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to hold the list of mapped variables for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import com.newgen.omni.wf.util.xml.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFVariableMapping
{
  private String systemDefinedName;
  private String userDefinedName;
  private int variableType;
  private String variableScope;
  private String extObjId;
  private String defaultValue;
  private int variableId; 
  private boolean unbounded; 
  
  public WFVariableMapping(String xml) throws XMLParseException
  {
    this.set(xml);
  }

  public WFVariableMapping(XMLParser parser) throws XMLParseException
  {
    this.set(parser);
  }

  public void set(String xml) throws XMLParseException
  {
    XMLParser parser = new XMLParser(xml);
    this.set(parser);
  }

  public void set(XMLParser parser) throws XMLParseException
  {
    this.setSystemDefinedName(parser.getStringValueOf("SystemDefinedName", 0, Integer.MAX_VALUE, true, null));
    this.setUserDefinedName(parser.getStringValueOf("UserDefinedName", 0, Integer.MAX_VALUE, false, systemDefinedName));
    this.setVariableType(Integer.parseInt(parser.getStringValueOf("VariableType", 0, Integer.MAX_VALUE, true, "0")));
    this.setVariableScope(parser.getStringValueOf("VariableScope", 0, Integer.MAX_VALUE, true, null));
    this.setExtObjId(parser.getStringValueOf("ExtObjId", 0, Integer.MAX_VALUE, true, null));
    this.setDefaultValue(parser.getStringValueOf("DefaultValue", 0, Integer.MAX_VALUE, false, null));
    this.setVariableId(Integer.parseInt(parser.getStringValueOf("VariableId", 0, Integer.MAX_VALUE, false, "0")));
    this.setArray(parser.getStringValueOf("Unbounded", 0, Integer.MAX_VALUE, false, "N").startsWith("Y"));
  }

  public String getSystemDefinedName()
  {
    return systemDefinedName;
  }

  public void setSystemDefinedName(String systemDefinedName)
  {
    this.systemDefinedName = systemDefinedName;
  }

  public String getUserDefinedName()
  {
    return userDefinedName;
  }

  public void setUserDefinedName(String userDefinedName)
  {
    this.userDefinedName = userDefinedName;
  }

  public int getVariableType()
  {
    return variableType;
  }

  public void setVariableType(int variableType)
  {
    this.variableType = variableType;
  }
  
  public void setVariableId(int variableId){
       this.variableId = variableId;
  }
   
  public int getVariableId(){
       return this.variableId;
  }
  
  public String getVariableScope()
  {
    return variableScope;
  }

  public void setVariableScope(String variableScope)
  {
    this.variableScope = variableScope;
  }

  public String getExtObjId()
  {
    return extObjId;
  }

  public void setExtObjId(String extObjId)
  {
    this.extObjId = extObjId;
  }

  public String getDefaultValue()
  {
    return defaultValue;
  }

  public void setDefaultValue(String defaultValue)
  {
    this.defaultValue = defaultValue;
  }
  
  public void setArray(boolean unbounded){
      this.unbounded = unbounded;
  }
  
  public boolean isArray(){
      return this.unbounded;
  }
  
  public boolean isComplexType(){
      return (this.variableType == 11);
  }
}