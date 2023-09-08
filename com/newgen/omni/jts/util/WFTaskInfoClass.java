//----------------------------------------------------------------------------------------------------
//                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : WorkFlow
//                   Module                   : iBPS Server
//                   File Name                : WFTaskInfoClass.java
//                   Author                   : Sajid Khan
//                   Date written (DD/MM/YYYY): 12/05/2015
//                   Description              : Task Info Class
//----------------------------------------------------------------------------------------------------
//                                CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                 Change By   		    Change Description (Bug No. (If Any))
//16/11/2015		Mohnish Chopra			Changes for Case Management -- Adding instance variable assgnBy for sending AssignedBy in GetTaskList
//04/07/2017		Shubhankur Manuja		Changes for DeclineTask API -- Adding rejectionComments varible for senting in GetTaskList
//26/07/2017        Kumar Kimil     Auto-Initiate Task based on Precondition
//28/08/2017        Ambuj Tripathi       Added fields for the UserGroups feature
//06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//07/02/2018        Kumar Kimil     Bug 72882 - WBL+Oracle: Incorrect workitem count is showing in quick search result
//------------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;

/**
 *
 * @author sajid.khan
 */
public class WFTaskInfoClass {

    public int taskId;
    public int subTaskId;
    public String taskName;
    public String isRepeatable;
    public int taskType;
    public String actionDate;
    public String assgnBy;
    public String assgnTo;
    public String isMandatory;
    public String dueDate;
    public String tatInMins;
    public int tempVarId;
    public String taskVarName;
    public String value;
    public int variableType;
    public String rejectionComments;
    public String instructions;
    public int TurnAroundTime;
    public int priority;

   
    

    public int defaultUserId;
    public String defaultUserName;
    public String defaultName;
    public String scope;
    public int defaultStatus=1;
    public String allowReassignment="Y";
    public String allowDecline="Y";
    public String approvalRequired="N";
    public String taskMode;
    public String expiredFlag;
    public String escalatedFlag;
    public String reworkFlag;
    public String waitingDescription;
    public String delayedFlag="N";
	
	public WFTaskInfoClass(int taskId,int subTaskId,String taskName,String isRepeatable, int taskType, String actionDate,String assgnBy,String assgnTo,String isMandatory,String dueDate,String tatInMins, String rejectionComments,String instructions,int TurnAroundTime, int priority) {
			this.taskId = taskId;
			this.subTaskId = subTaskId;
			this.taskName = taskName;
			this.isRepeatable = isRepeatable;
			this.taskType = taskType;
			this.actionDate = actionDate;
			this.assgnBy = assgnBy;
			this.assgnTo = assgnTo;
			this.isMandatory = isMandatory;
			this.dueDate = dueDate;
			this.tatInMins = tatInMins;
			this.rejectionComments = rejectionComments;
			this.instructions=instructions;
			this.TurnAroundTime=TurnAroundTime;
			this.priority= priority;
			
	}



	public WFTaskInfoClass(int taskId,int subTaskId,String taskName,String isRepeatable, int taskType, String actionDate,String assgnBy,String assgnTo,String isMandatory,String dueDate,String tatInMins, String rejectionComments,String instructions,int TurnAroundTime, int priority, int defUserId, String defUserName, String defPersonalName, String scope,String taskMode,String expiredFlag,String escalatedFlag,String reworkFlag,String waitingDescription,String delayedFlag) {

        this.taskId = taskId;
        this.subTaskId = subTaskId;
        this.taskName = taskName;
        this.isRepeatable = isRepeatable;
        this.taskType = taskType;
        this.actionDate = actionDate;
        this.assgnBy = assgnBy;
        this.assgnTo = assgnTo;
        this.isMandatory = isMandatory;
        this.dueDate = dueDate;
        this.tatInMins = tatInMins;
		this.rejectionComments = rejectionComments;
		this.instructions=instructions;
		this.TurnAroundTime=TurnAroundTime;
		this.priority= priority;
		this.defaultUserId = defUserId;
		this.defaultUserName = defUserName;
		this.defaultName = defPersonalName;
		this.scope = scope;

		this.taskMode=taskMode;
		this.expiredFlag=expiredFlag;
		this.escalatedFlag=escalatedFlag;
		this.reworkFlag=reworkFlag;
		this.waitingDescription=waitingDescription;
		this.delayedFlag=delayedFlag;

	}

    
    public WFTaskInfoClass(int tempVarId,String taskVarName,String value,int variableType) {
        this.tempVarId = tempVarId;
        this.taskVarName = taskVarName;
        this.value = value;
        this.variableType = variableType;
    }

	
}// class TaskInfoClass