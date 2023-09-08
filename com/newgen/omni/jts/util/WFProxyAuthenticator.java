/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFProxyAuthenticator.java
             Author				: Ruhi Hira
             Date written		: 10/02/2006
             Description		: ProxyAuthenticator class for weblogic
                                    application server [Bug # WFS_6.1.2_051].
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.util;

import weblogic.common.ProxyAuthenticator;

public class WFProxyAuthenticator implements ProxyAuthenticator{

    private static String userName = null;
    private static String strpass_word = null;
    private String proxyHost = null;
    private int proxyPort = 0;
    private String authType = null;
    private String loginPrompt = null;

    /**
     * *******************************************************************************
     *      Function Name       : Constructor
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFProxyAuthenticator Object
     *      Description         : Constructor.
     * *******************************************************************************
     */
    public WFProxyAuthenticator() {
    }

    /**
     * *******************************************************************************
     *      Function Name       : init [interface method]
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    :   String  proxyHost
     *                              int     proxyPort
     *                              String  authType
     *                              String  loginPrompt
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : to initialize proxy server settings.
     * *******************************************************************************
     */
    public void init(String inProxyHost, int inProxyPort, String inAuthType, String inLoginPrompt){
        this.proxyHost = inProxyHost;
        this.proxyPort = inProxyPort;
        this.authType = inAuthType;
        this.loginPrompt = inLoginPrompt;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setLoginAndPassword
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    :   String  username
     *                              String  password
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for login and password for proxy server.
     * *******************************************************************************
     */
    public static void setLoginAndPassword(String inUserName, String inPassword){
        userName = inUserName;
        strpass_word = inPassword;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getLoginAndPassword [interface method]
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String[] {userName, password}
     *      Description         : getter for login and password for proxy server.
     * *******************************************************************************
     */
    public String[] getLoginAndPassword(){
        return new String[]{ userName, strpass_word };
    }

    /**
     * *******************************************************************************
     *      Function Name       : getProxyPort
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : int proxyPort
     *      Description         : getter for proxyPort.
     * *******************************************************************************
     */
    public int getProxyPort() {
        return proxyPort;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setProxyPort
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String proxyPort
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for proxyPort.
     * *******************************************************************************
     */
    public void setProxyPort(int proxyPort) {
        this.proxyPort = proxyPort;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getProxyHost
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String proxyHost
     *      Description         : getter for proxyHost.
     * *******************************************************************************
     */
    public String getProxyHost() {
        return proxyHost;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setProxyHost
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String proxyHost
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for proxyHost.
     * *******************************************************************************
     */
    public void setProxyHost(String proxyHost) {
        this.proxyHost = proxyHost;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getLoginPrompt
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String loginPrompt
     *      Description         : getter for loginPrompt.
     * *******************************************************************************
     */
    public String getLoginPrompt() {
        return loginPrompt;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setLoginPrompt
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String loginPrompt
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for loginPrompt.
     * *******************************************************************************
     */
    public void setLoginPrompt(String loginPrompt) {
        this.loginPrompt = loginPrompt;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getAuthType
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : String authType
     *      Description         : getter for authType.
     * *******************************************************************************
     */
    public String getAuthType() {
        return authType;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setAuthType
     *      Date Written        : 10/02/2006
     *      Author              : Ruhi Hira
     *      Input Parameters    : String authType
     *      Output Parameters   : NONE
     *      Return Values       : NONE
     *      Description         : setter for authType.
     * *******************************************************************************
     */
    public void setAuthType(String authType) {
        this.authType = authType;
    }
}
