/*------------------------------------------------------------------------------------------------------------
	      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
 Group			: Genesis Group
 Product 		: iBPS 5.0
 Module			: OmniFlow Server
 File Name 		: WFVariableMappings.java
 Author			: Ambuj Tripathi
 Date written 	: 20/12/2019
 Description 	: Structure to contain the operations performed on list of mappings for data exchange
 --------------------------------------------------------------------------------------------------------------
			    CHANGE HISTORY
 --------------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. If Any)
 --------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.util.dx;

import java.sql.Connection;
import java.util.Hashtable;

import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.util.dx.WFVariableMapping;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFVariableMappings
{
  private Hashtable<String, WFVariableMapping> variables = new Hashtable<String, WFVariableMapping>();

  public WFVariableMappings(String xml) throws XMLParseException
  {
    this.set(xml);
  }

  public WFVariableMappings(XMLParser parser) throws XMLParseException
  {
    this.set(parser);
  }

  public WFVariableMappings(Connection con, int ProcessDefId)
  {
    /*
       SELECT     SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue
      FROM         VarMappingTable VariableMappings
     */
  }

  public void set(String xml) throws XMLParseException
  {
    XMLParser parser = new XMLParser(xml);
    this.set(parser);
  }

  public void set(XMLParser parser) throws XMLParseException
  {
    NGXmlList mappings = parser.createList("VariableMappings", "VariableMapping");
    for(mappings.reInitialize(); mappings.hasMoreElements(); mappings.skip())
    {
      WFVariableMapping variable = new WFVariableMapping(mappings.getVal("VariableMapping"));
      variables.put(variable.getUserDefinedName().toUpperCase(), variable);
    }
  }

  public WFVariableMapping get(String variable)
  {
    return variables.get(variable.toUpperCase());
  }
  
  public Hashtable<String, WFVariableMapping> getVariablesTable(){
      return this.variables;
  }

  public String getSystemDefinedName(String variable)
  {
    WFVariableMapping var =  variables.get(variable.toUpperCase());
    if(var == null)
      return null;
    return var.getSystemDefinedName();
  }

  public String getExtObjId(String variable)
  {
    WFVariableMapping var = variables.get(variable.toUpperCase());
    if(var == null)
      return null;

    return var.getExtObjId();
  }

  public int getVariableType(String variable)
  {
    WFVariableMapping var =  variables.get(variable.toUpperCase());
    /*to be checked*/
    if(var == null){
        return 0;
    }
    return var.getVariableType();
  }
  /*
   Changed By: Shilpi Srivastava
   Changed On: 2nd May 2008
   Changed For: Complex data type support*/
  public int getVariableId(String variable){
      WFVariableMapping var =  variables.get(variable.toUpperCase());
      return var.getVariableId();
  }
  
  public boolean isArray(String variable){
      WFVariableMapping var =  variables.get(variable.toUpperCase());
      return var.isArray();
  } 
  
  public boolean isComplexType(String variable){
      return (this.getVariableType(variable)== 11);
  }
}