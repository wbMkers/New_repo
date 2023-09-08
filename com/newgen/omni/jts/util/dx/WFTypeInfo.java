package com.newgen.omni.jts.util.dx;

import com.newgen.omni.wf.util.xml.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFTypeInfo {

    private int parentTypeId;
    private int typeFieldId;
    private String fieldName;
    private int WFType;
    private int typeId;
    private boolean unbounded;

    public WFTypeInfo(String xml) throws XMLParseException{
        this.set(xml);
    }
    
    public WFTypeInfo(XMLParser xml) throws XMLParseException{
        this.set(xml);
    }
    
    public void set(String xml) throws XMLParseException{
        this.set(new XMLParser(xml));
    }
    
    public void set(XMLParser parser) throws XMLParseException{
        this.setParentTypeId(Integer.parseInt(parser.getStringValueOf("ParentTypeId", 0, Integer.MAX_VALUE, true, null)));
        this.setTypeFieldId(Integer.parseInt(parser.getStringValueOf("TypeFieldId", 0, Integer.MAX_VALUE, true, null)));
        this.setFieldName(parser.getStringValueOf("FieldName", 0, Integer.MAX_VALUE, true, null));
        this.setWFType(Integer.parseInt(parser.getStringValueOf("WFType", 0, Integer.MAX_VALUE, true, null)));
        this.setTypeId(Integer.parseInt(parser.getStringValueOf("TypeId", 0, Integer.MAX_VALUE, true, null)));
        this.setArray(parser.getStringValueOf("Unbounded", 0, Integer.MAX_VALUE, true, null).equalsIgnoreCase("Y"));
    }
    
    public int getParentTypeId() {
        return this.parentTypeId;
    }

    public int getTypeFieldId() {
        return this.typeFieldId;
    }

    public String getFieldName() {
        return this.fieldName;
    }

    public int getWFType() {
        return this.WFType;
    }

    public int getTypeId() {
        return this.typeId;
    }

    public boolean isArray() {
        return this.unbounded;
    }
    public void setParentTypeId(int parentTypeId) {
        this.parentTypeId = parentTypeId;
    }

    public void setTypeFieldId(int typeFieldId) {
        this.typeFieldId = typeFieldId;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public void setWFType(int wfType) {
        this.WFType = wfType;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public void setArray(boolean isArray) {
        this.unbounded = isArray;
    }
}
