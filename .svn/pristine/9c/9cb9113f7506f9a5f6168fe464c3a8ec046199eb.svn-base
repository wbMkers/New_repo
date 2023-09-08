package com.newgen.omni.jts.util.dx;

import com.newgen.omni.wf.util.xml.WFXmlList;
import com.newgen.omni.wf.util.xml.XMLParser;
import com.newgen.omni.wf.util.xml.exception.XMLParseException;

public class WFUDTVarMappingInfo {
    
    private int VariableId;
    private int VarFieldId;
    private int TypeId;
    private int TypeFieldId;
    private int ParentVarFieldId;
    
    public WFUDTVarMappingInfo(String xml) throws XMLParseException{
        this.set(xml);
    }
    
    public WFUDTVarMappingInfo(XMLParser parser) throws XMLParseException{
        this.set(parser);
    }
    public void set(String xml) throws XMLParseException{
        this.set(new XMLParser(xml));
    }
    public void set(XMLParser parser) throws XMLParseException{
        this.setVariableId(Integer.parseInt(parser.getStringValueOf("VariableId", 0, Integer.MAX_VALUE, true, null)));
        this.setVarFieldId(Integer.parseInt(parser.getStringValueOf("VarFieldId", 0, Integer.MAX_VALUE, true, null)));
        this.setTypeId(Integer.parseInt(parser.getStringValueOf("TypeId", 0, Integer.MAX_VALUE, true, null)));
        this.setTypeFieldId(Integer.parseInt(parser.getStringValueOf("TypeFieldId", 0, Integer.MAX_VALUE, true, null)));
        this.setParentVarFieldId(Integer.parseInt(parser.getStringValueOf("ParentVarFieldId", 0, Integer.MAX_VALUE, true, null)));
    }
    public int getVariableId() {
        return this.VariableId;
    }

    public int getVarFieldId() {
        return this.VarFieldId;
    }

    public int getTypeId() {
        return this.TypeId;
    }

    public int getTypeFieldId() {
        return this.TypeFieldId;
    }

    public int getParentVarFieldId() {
        return this.ParentVarFieldId;
    }
    
    public void setVariableId(int variableId) {
        this.VariableId = variableId;
    }

    public void setVarFieldId(int varFieldId) {
        this.VarFieldId = varFieldId;
    }

    public void setTypeId(int typeId) {
        this.TypeId = typeId;
    }

    public void setTypeFieldId(int typeFieldId) {
        this.TypeFieldId = typeFieldId;
    }

    public void setParentVarFieldId(int parentVarFieldId) {
        this.ParentVarFieldId = parentVarFieldId;
    }
}
