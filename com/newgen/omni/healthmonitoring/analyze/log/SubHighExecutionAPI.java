package com.newgen.omni.healthmonitoring.analyze.log;



public class SubHighExecutionAPI {
    private Integer executionTime;
    private String fileName;
    private String parameter;
    private String dateTime;
    
    public SubHighExecutionAPI(){
    
    }
    public SubHighExecutionAPI(Integer executionTime, String fileName, String parameter, String dateTime) {
        this.executionTime = executionTime;
        this.fileName = fileName;
        this.parameter = parameter;
        this.dateTime = dateTime;
    }
    public void setExecutionTime(Integer executionTime){
        this.executionTime = executionTime;
    }
    public Integer getExecutionTime(){
        return executionTime;
    }
    public void setFileName(String fileName){
        this.fileName = fileName;
    }
    public String getFileName(){
        return fileName;
    }
    public void setParameter(String parameter){
        this.parameter = parameter;
    }
    public String getParameter(){
        return parameter;
    }
    public void setDateTime(String dateTime){
        this.dateTime = dateTime;
    }
    public String getDateTime(){
        return dateTime;
    }
}


