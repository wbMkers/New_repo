package com.newgen.omni.jts.util.dx;
/*
   Changed By: Shilpi Srivastava
   Changed On: 2nd May 2008
   Changed For: Complex data type support*/
  
import java.util.*;

import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFTypeInfoMappings
{
  private HashMap<String, WFTypeInfo> typeInfoMap = new HashMap<String, WFTypeInfo>();

  public WFTypeInfoMappings(String xml) throws XMLParseException
  {
    this.set(xml);
  }

  public WFTypeInfoMappings(XMLParser parser) throws XMLParseException
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
	  NGXmlList mappings = parser.createList("UserDefinedTypeInfo", "UserDefinedType");
    WFTypeInfo  typeInfo = null;
    for(mappings.reInitialize(); mappings.hasMoreElements(); mappings.skip())
    {
      typeInfo = new WFTypeInfo(mappings.getVal("UserDefinedType"));
      String key = typeInfo.getParentTypeId() + "#" + typeInfo.getTypeFieldId();
      typeInfoMap.put(key.toUpperCase() , typeInfo);
    }
  }

  public WFTypeInfo get(String typeKey)
  {
    return typeInfoMap.get(typeKey.toUpperCase());
  }

  public WFTypeInfo get(int parentTypeId, int typeFieldId){
      String key = parentTypeId + "#" + typeFieldId;
      return typeInfoMap.get(key);
  }
  
  public String getFieldName(int parentTypeId ,  int typeFieldId)
  {
    String key = parentTypeId + "#" + typeFieldId;
    return typeInfoMap.get(key).getFieldName();
  }
  
  public int getWFType(int parentTypeId ,  int typeFieldId){
      String key = parentTypeId + "#" + typeFieldId;
      return typeInfoMap.get(key).getWFType();
  }
  
  public int getTypeId(int parentTypeId ,  int typeFieldId){
      String key = parentTypeId + "#" + typeFieldId;
      return typeInfoMap.get(key).getTypeId();
  }
 
  public boolean isArray(int parentTypeId ,  int typeFieldId){
      String key = parentTypeId + "#" + typeFieldId;
      return typeInfoMap.get(key).isArray();
  } 
  
  public String getFieldName(String key)
  {
    return typeInfoMap.get(key.toUpperCase()).getFieldName();
  }
  
  public int getWFType(String key){
      return typeInfoMap.get(key.toUpperCase()).getWFType();
  }
  
  public int getTypeId(String key){
      return typeInfoMap.get(key.toUpperCase()).getTypeId();
  }
 
  public boolean isArray(String key){
      return typeInfoMap.get(key.toUpperCase()).isArray();
  }
}