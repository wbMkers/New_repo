/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.newgen.omni.jts.util;

import java.sql.Connection;

/**
 *
 * @author sajid.khan
 */
public class WFUserApiContext {


    private String apiName = null;
	private char participantType ;
    private String userName;
    private String locale;

	private Connection con=null;


   public void setApiName(String _apiName){
       apiName = _apiName;
   }

   public String getApiName(){
       return apiName;
   }

     public void setUserName(String _userName){
       userName = _userName;
   }

   public String getUserName(){
       return userName;
   }
   
   public void setLocale(String _locale){
       locale = _locale;
   }

   public String getLocale(){
       return locale;
   }
   
	public void setParticipantType(char _participantType){
		participantType = _participantType;
	}
	
	public char  getParticipantType(){
		return participantType ;
	}
	
	public Connection getConnection() {
		return con;
	}

	public void setConnection(Connection con) {
		this.con = con;
	}
}
