package com.newgen.omni.healthmonitoring.analyze.log;




public class WFHealthIdentityRecord {
    private int entityType, subEntityType, riskCategory;
    private String tableName, columnName, dataType;
    private Long limit, currentValue;
    private double occupancy;
    
    public WFHealthIdentityRecord(int entityType, int subEntityType, String tableName, String columnName, String dataType, Long limit, Long currentValue,  double occupancy, int riskCategory){
        this.entityType = entityType;
        this.subEntityType = subEntityType;
        this.tableName = tableName;
        this.columnName = columnName;
        this.dataType = dataType;
        this.limit = limit;
        this.currentValue = currentValue;
        this.occupancy = occupancy;
        this.riskCategory = riskCategory;
    }
    
    public void setEntityType(int entityType){
        this.entityType = entityType;
    }
    public int getEntityType(){
        return entityType;
    }
    public void setSubEntityType(int subEntityType){
        this.subEntityType = subEntityType;
    }
    public int getSubEntityType(){
        return subEntityType;
    }
    public void setRiskCategory(int riskCategory){
        this.riskCategory = riskCategory;
    }
    public int getRiskCategory(){
        return riskCategory;
    }
    public void setTableName(String tableName){
        this.tableName = tableName;
    }
    public String getTableName(){
        return tableName;
    }
    public void setColumnName(String columnName){
        this.columnName = columnName;
    }
    public String getColumnName(){
        return columnName;
    }
    public void setDataType(String dataType){
        this.dataType = dataType;
    }
    public String getDataType(){
        return dataType;
    }
    public void setLimit(Long limit){
        this.limit = limit;
    }
    public Long getLimit(){
        return limit;
    }
    public void setCurrentValue(Long currentValue){
        this.currentValue = currentValue;
    }
    public Long getCurrentValue(){
        return currentValue;
    }
    public void setOccupancy(double occupancy){
        this.occupancy = occupancy;
    }
    public double getOccupancy(){
        return occupancy;
    }
}
