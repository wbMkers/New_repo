//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products
//	Product / Project			: WorkFlow
//	Module						: Transaction Server
//	File Name					: WFUserInfo.java
//	Author						: Indraneel Dasgupta
//	Date written (DD/MM/YYYY)	: 07/10/2009
//	Description					: Data structure to store user properties
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

public class WFUserInfo {
	private int userId = 0;
	private String userName;
	private String personalName;
	private String familyName;

	public WFUserInfo() {
	}

	public WFUserInfo(int userId, String userName, String personalName, String familyName) {
		this.userId = userId;
		this.userName = userName;
		this.personalName = personalName;
		this.familyName = familyName;
	}

	public void setUserName(String userName){
		this.userName = userName;
	}

	public String getUserName(){
		return userName;
	}

	public void setPersonalName(String personalName){
		this.personalName = personalName;
	}

	public String getPersonalName(){
		return personalName;
	}

	public void setFamilyName(String familyName){
		this.familyName = familyName;
	}

	public String getFamilyName(){
		return familyName;
	}
	public void setUserId(int userId){
		this.userId = userId;
	}

	public int getUserId(){
		return userId;
	}

}