// -----------------------------------------------------------------------------------------
//		    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// -----------------------------------------------------------------------------------------
//	    Group					    : Application Products
//	    Product / Project	        : WorkFlow
//	    Module					    : Transaction Server
//	    File Name				    : WFExternalInterface.java
//	    Author					    : Prashant
//	    Date written (DD/MM/YYYY)	: 16/05/2002
//	    Description			        : Data structure to hold user info who has connected.
// -----------------------------------------------------------------------------------------
//		            	CHANGE HISTORY
// -----------------------------------------------------------------------------------------
// Date(DD/MM/YYYY)	Change By		Change Description (Bug No. (If Any))
// -----------------------------------------------------------------------------------------
// 05/06/2007       Ruhi Hira       WFS_5_161, MultiLingual Support (Inherited from 5.0).
// 19/10/2021		Vardaan Arora	Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
// //11/02/2022		Vardaan Arora	Code optimisation for process server so that it does not retrieve data of complex variables in WMGetNextWorkItem call
//
//
//
// -----------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wapi;

public class WFParticipant{
    private int id;
    private String name;
    private char type;
    private String scope;
    private String locale;
    private int parentGroupIndex = 0;
    private boolean isPSFlag = false;
    
    public WFParticipant(int id, String name, char type, String scope){
        this(id, name, type, scope, "");
    }

    public WFParticipant(int id, String name, char type, String scope, String locale){
        this.id = id;
        this.name = name.trim();
        this.type = type;
        this.scope = scope.trim();
        this.type = scope.equalsIgnoreCase("SYSTEM") ? 'U' : type;
        /* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
        if(locale != null){
            this.locale = locale.trim();
        }
    }
    
    public void setParentGroupIndex(int parentIndex) {
    	this.parentGroupIndex = parentIndex;
    }
    
    public void setPSFlag(boolean isPSFlag) {
    	this.isPSFlag = isPSFlag;
    }
    
    public int getid(){
        return id;
    }

    public String getname(){
        return name;
    }

    public char gettype(){
        return type;
    }

    public String getscope(){
        return scope;
    }

    public String getlocale() {
      return locale;
    }
    
    public int getParentGroupIndex() {
    	return parentGroupIndex;
    }
    
    public boolean getPSFlag() {
    	return isPSFlag;
    }
}