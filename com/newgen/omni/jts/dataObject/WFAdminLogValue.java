//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFAdminLogValue.java
//	Author						: Shweta Singhal
//	Date written (DD/MM/YYYY)	: 03/01/2013
//	Description					: 

//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//  27/12/2012	Sajid Khan		Bug 37345 - Audit trail Issue.
// 04/01/2013	Shweta Singhal		New Field are added for Right Management Auditing
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

public class WFAdminLogValue {

	private int fieldId1;
    private String fieldName1;
	private int fieldId2;
    private String fieldName2;
	private String property;
	private String oldValue;
	private String newValue;
	private String wefDate;
	private String validTillDate;
	private String operation;			//Bug 37345  
	private int actionId; 
	private int procDefId;
	private int queueId;
	private String queueName;
	private int userId;
	private String userName;
	private int profileId;
	private String profileName;
	private String property1;
	
	public WFAdminLogValue(int fieldId1, String fieldName1, int fieldId2, String fieldName2, String property, String oldValue, String newValue, String wefDate, String validTillDate, String operation) {
		this.fieldId1 = fieldId1;
		this.fieldName1 = fieldName1;
		this.fieldId2 = fieldId2;
		this.fieldName2 = fieldName2;
		this.property = property;
		this.oldValue = oldValue;
		this.newValue = newValue;
		this.wefDate = wefDate;
		this.validTillDate = validTillDate;
		this.operation = operation;		//Bug 37345
	}
		
    public WFAdminLogValue(int fieldId1, String fieldName1, int fieldId2, String fieldName2, String property, String oldValue, String newValue, String wefDate, String validTillDate, String operation, int actionId, int procDefId, int queueId, String queueName, int userId, String userName, int profileId, String profileName, String property1) {
		this.fieldId1 = fieldId1;
		this.fieldName1 = fieldName1;
		this.fieldId2 = fieldId2;
		this.fieldName2 = fieldName2;
		this.property = property;
		this.oldValue = oldValue;
		this.newValue = newValue;
		this.wefDate = wefDate;
		this.validTillDate = validTillDate;
		this.operation = operation;		//Bug 37345
		this.actionId = actionId;
		this.procDefId = procDefId;
		this.queueId = queueId;
		this.queueName = queueName;
		this.userId = userId;
		this.userName = userName;
		//Added for Right Management Auditing
		this.profileId = profileId;
		this.profileName = profileName;
		this.property1 = property1;
	}
	
	public int getFieldId1() {
        return fieldId1;
    }
    
    public void setFieldId1(int fieldId1) {
        this.fieldId1 = fieldId1;
    }
	
	public String getFieldName1() {
        return fieldName1;
    }
    
    public void setFieldName1(String fieldName1) {
        this.fieldName1 = fieldName1;
    }
	
	public int getFieldId2() {
        return fieldId2;
    }
    
    public void setFieldId2(int fieldId2) {
        this.fieldId2 = fieldId2;
    }

	public String getFieldName2() {
        return fieldName2;
    }
    
    public void setFieldName2(String fieldName2) {
        this.fieldName2 = fieldName2;
    }	
	
	public String getProperty() {
        return property;
    }
    
    public void setProperty(String property) {
        this.property = property;
    }
	
	public String getOldValue() {
        return oldValue;
    }
    
    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }
	
	public String getNewValue() {
        return newValue;
    }
    
    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }
	
	public String getWefDate() {
        return wefDate;
    }
    
    public void setWefDate(String wefDate) {
        this.wefDate = wefDate;
    }
	
	public String getValidTillDate() {
        return validTillDate;
    }
    
    public void setValidTillDate(String validTillDate) {
        this.validTillDate = validTillDate;
    }
	
	public String getOperation() {
        return operation;
    }
    
    public void setOperation(String operation) {
        this.operation = operation;
    }
	
	public int getActionId() {
        return actionId;
    }
    
    public void setActionId(int actionId) {
        this.actionId = actionId;
    }
	
	public int getProcDefId() {
        return procDefId;
    }
    
    public void setProcDefId(int procDefId) {
        this.procDefId = procDefId;
    }
	
	public int getQueueId() {
        return queueId;
    }
    
    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }
	
	public String getQueueName() {
        return queueName;
    }
    
    public void setQueueName(String queueName) {
        this.queueName = queueName;
    }
	
	public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
	
	public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
	
	public int getProfileId() {
        return profileId;
    }
    
    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }
	
	public String getProfileName() {
        return profileName;
    }
    
    public void setProfileName(String profileName) {
        this.profileName = profileName;
    }
	
	public String getProperty1() {
        return property1;
    }
    
    public void setProperty1(String property1) {
        this.property1 = property1;
    }
}