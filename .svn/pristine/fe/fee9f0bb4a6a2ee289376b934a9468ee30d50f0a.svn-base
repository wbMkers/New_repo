package com.newgen.omni.healthmonitoring.analyze.log;


import java.util.ArrayList;
import java.util.HashMap;

import com.sun.prism.impl.Disposer.Record;

public class RecordData {

    private int category;
    private int entity_type;
    private HashMap<Integer, ArrayList<com.newgen.omni.healthmonitoring.analyze.log.Record>> severityMap = new HashMap();
    private HashMap<Integer, ArrayList<Record>> entityMap = new HashMap();

    public RecordData() {
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }
    
    public int getEntity_Type(){
        return entity_type;
    }

    public void setEntity_Type(int entity_type){
        this.entity_type = entity_type;
    }
    public HashMap<Integer, ArrayList<com.newgen.omni.healthmonitoring.analyze.log.Record>> getSeverityMap() {
        return severityMap;
    }

    public void setSeverityMap(HashMap<Integer, ArrayList<com.newgen.omni.healthmonitoring.analyze.log.Record>> map1) {
        this.severityMap = map1;
    }
    
    public HashMap<Integer, ArrayList<Record>> getEntityMap() {
        return entityMap;
    }

    public void setEntityMap(HashMap<Integer, ArrayList<Record>> entityMap) {
        this.entityMap = entityMap;
    }

}
