package com.newgen.omni.jts.util.dx;
/*
   Changed By: Shilpi Srivastava
   Changed On: 2nd May 2008
   Changed For: Complex data type support*/
  
import java.util.*;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFUDTVarMappings
{
  private LinkedHashMap<String, WFUDTVarMappingInfo> udtVarInfoMap = new LinkedHashMap<String, WFUDTVarMappingInfo>();

  public WFUDTVarMappings(String xml) throws XMLParseException
  {
    this.set(xml);
  }

  public WFUDTVarMappings(XMLParser parser) throws XMLParseException
  {
    this.set(parser);
  }

  public LinkedHashMap<String, WFUDTVarMappingInfo> getUDTVarMap(){
      return this.udtVarInfoMap;
  }
          
  public void set(String xml) throws XMLParseException
  {
    XMLParser parser = new XMLParser(xml);
    this.set(parser);
  }

  public void set(XMLParser parser) throws XMLParseException
  {
	  NGXmlList mappings = parser.createList("UserDefinedVarInfo", "UserDefinedVar");
    WFUDTVarMappingInfo udtVarInfo = null;
    for(mappings.reInitialize(); mappings.hasMoreElements(); mappings.skip())
    {
      udtVarInfo = new WFUDTVarMappingInfo(mappings.getVal("UserDefinedVar"));
      String key = udtVarInfo.getVariableId() + "#" + udtVarInfo.getVarFieldId();
      udtVarInfoMap.put(key.toUpperCase() , udtVarInfo);
    }
  }

  public WFUDTVarMappingInfo get(String typeKey)
  {
    return udtVarInfoMap.get(typeKey.toUpperCase());
  }

  public WFUDTVarMappingInfo get(int variableId, int varFieldId){
      String key = variableId + "#" + varFieldId;
      return udtVarInfoMap.get(key);
  }
  
  public int getTypeId(int variableId ,  int varFieldId)
  {
    String key = variableId + "#" + varFieldId;
    return udtVarInfoMap.get(key).getTypeId();
  }
  
  public int getTypeFieldId(int variableId ,  int varFieldId){
      String key = variableId + "#" + varFieldId;
      return udtVarInfoMap.get(key).getTypeFieldId();
  }
  
  public int getParentVarFieldId(int variableId ,  int varFieldId){
      String key = variableId + "#" + varFieldId;
      return udtVarInfoMap.get(key).getParentVarFieldId();
  }
  
  public int getTypeId(String key)
  {
    return udtVarInfoMap.get(key.toUpperCase()).getTypeId();
  }
  
  public int getTypeFieldId(String key){
      return udtVarInfoMap.get(key.toUpperCase()).getTypeFieldId();
  }
  
  public int getParentVarFieldId(String key){
      return udtVarInfoMap.get(key.toUpperCase()).getParentVarFieldId();
  }
}