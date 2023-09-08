//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSInfo.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 07/01/2010
// Description				:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.dataObject;

/**
 *
 * @author saurabh.kamal
 */
public class WFTMSInfo {
	private String targetCabinetName = null;
	private String targetAppServerIp = null;
	private int targetAppServerPort = 0;
	private String targetAppServerType = null;
	private String tUserName = null;
	private String tPass_word = null;
	private String sourceCabinetName = null;

	/**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 11/01/2008
     *      Author              : Saurabh Kamal
     *      Input Parameters    : String tCabinetName, String tAppServerIp, int tAppServerPort, String tAppServerType
     *      Output Parameters   : NONE
     *      Return Values       : WFTMSInfo object
     *      Description         : constructor for this class, WFTMSInfo.
     * *******************************************************************************
     */

	public WFTMSInfo(String tCabinetName, String tAppServerIp, int tAppServerPort, String tAppServerType){
		targetCabinetName = tCabinetName;
		targetAppServerIp = tAppServerIp;
		targetAppServerPort = tAppServerPort;
		targetAppServerType = tAppServerType;
	}

	/**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 11/01/2008
     *      Author              : Saurabh Kamal
     *      Input Parameters    : String tCabinetName, String tAppServerIp, int tAppServerPort, String tAppServerType
     *      Output Parameters   : NONE
     *      Return Values       : WFTMSInfo object
     *      Description         : constructor for this class, WFTMSInfo.
     * *******************************************************************************
     */

	public WFTMSInfo(String tCabinetName, String tAppServerIp, int tAppServerPort, String tAppServerType, String userName, String password, String sCabinetName){
		targetCabinetName = tCabinetName;
		targetAppServerIp = tAppServerIp;
		targetAppServerPort = tAppServerPort;
		targetAppServerType = tAppServerType;
		tUserName = userName;
		tPass_word = password;
        sourceCabinetName = sCabinetName;

	}

	public String getTargetCabinet() {
        return targetCabinetName;
    }
	public String getTargetAppServerIp() {
        return targetAppServerIp;
    }
	public int getTargetAppServerPort() {
        return targetAppServerPort;
    }
	public String getTargetAppServerType() {
        return targetAppServerType;
    }
	public String getUserName() {
        return tUserName;
    }
	public String getPassword() {
        return tPass_word;
    }
	public String getSourceCabinetName() {
        return sourceCabinetName;
    }
}
