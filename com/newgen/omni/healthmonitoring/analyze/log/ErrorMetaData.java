package com.newgen.omni.healthmonitoring.analyze.log;



import java.util.ArrayList;
import java.util.HashMap;

public class ErrorMetaData {

    private String productName;
    private HashMap<String, Integer> errorDataMap;
    private HashMap<String, ArrayList<String>> errorFileName;
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public HashMap<String, ArrayList<String>> getErrorFileNameMap(){
        return errorFileName;
    }
    public void setErrorFileNameMap(HashMap<String, ArrayList<String>> errorFileName){
        this.errorFileName = errorFileName;
    }
    public HashMap<String, Integer> getErrorDataMap() {
        return errorDataMap;
    }

    public void setErrorDataMap(HashMap<String, Integer> errorDataMap) {
        this.errorDataMap = errorDataMap;
    }
}

