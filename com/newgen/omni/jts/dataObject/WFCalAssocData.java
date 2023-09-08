//----------------------------------------------------------------------------------------------------
//      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//  Group                       : Phoenix
//  Product / Project           : OmniFlow
//  Module                      : OmniFlow Server
//  File Name                   : WFCalAssocData.java
//  Author                      : Ahsan Javed
//  Date written (DD/MM/YYYY)   : 01/02/2007
//  Description                 : represents calendar association data and gives its getter and setter methods.
//----------------------------------------------------------------------------------------------------
//          CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                     Change By       Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.dataObject;

public class WFCalAssocData {

    private int calId;
    private int processDefId;
    private char calType;
    private char tatCalFlag;
    private char expCalFlag;

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : WFCalAssocData
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : none
    Output Parameters                      : none
    Return Values                          : none
    Description                            : constuctor of WFCalAssocData
    ------------------------------------------------------------------------------------------------------
    */

    public WFCalAssocData() {
        calId = 0;
        processDefId = 0;
    }

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : WFCalAssocData
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : int calId, int processDefId
    Output Parameters                      : none
    Return Values                          : none
    Description                            : constuctor of WFCalAssocData
    ------------------------------------------------------------------------------------------------------
    */

    public WFCalAssocData(int calId, int processDefId, char calType, char tatCalFlag, char expCalFlag) {
        this.calId = calId;
        this.processDefId = processDefId;
        this.calType = calType;
        this.tatCalFlag = tatCalFlag;
        this.expCalFlag = expCalFlag;
    }

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : getCalId
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : none
    Output Parameters                      : none
    Return Values                          : int
    Description                            : returns the calendar Id
    ------------------------------------------------------------------------------------------------------
    */

    public int getCalId() {
        return this.calId;
    }

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : setCalId
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : int calId
    Output Parameters                      : none
    Return Values                          : none
    Description                            : sets the calendar Id
    ------------------------------------------------------------------------------------------------------
    */

//    public void setCalId(int calId) {
//        this.calId = calId;
//    }

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : getProcessDefId
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : none
    Output Parameters                      : none
    Return Values                          : int
    Description                            : returns the processDefId
    ------------------------------------------------------------------------------------------------------
    */

    public int getProcessDefId() {
        return this.processDefId;
    }

    /*----------------------------------------------------------------------------------------------------
    Function Name                          : setProcessDefId
    Date Written (DD/MM/YYYY)              : 01/02/2007
    Author                                 : Ahsan Javed
    Input Parameters                       : int processDefId
    Output Parameters                      : none
    Return Values                          : none
    Description                            : sets the processDefId
    ------------------------------------------------------------------------------------------------------
    */

//    public void setProcessDefId(int processDefId) {
//        this.processDefId = processDefId;
//    }

   public char getCalType() {
       return this.calType;
   }

   public char getTatCalFlag() {
       return this.tatCalFlag;
   }

   public char getExpCalFlag() {
       return this.expCalFlag;
   }

}
