//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group				: Phoenix
//	Product / Project		: Omniflow
//	Module				: Transaction Server
//	File Name			: WFActviity.java
//	Author				: Shilpi S
//	Date written (DD/MM/YYYY)	: 17/12/2008
//	Description			: 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 17/11/2008                                   Shilpi S                SrNo-1, BPEL Event Handling in Omniflow
// 08/12/2017									Mohnish Chopra			Prdp Bug 71731 - Audit log generation for change/set user preferences

package com.newgen.omni.jts.dataObject;

public class WFActivityInfo{
    
    public String eventId;
    public String actvScopeId;
    public String eventScopeId;
    public String activityId;
    public String activityName;
    public WFActivityInfo(){
        
    }
    public WFActivityInfo(String eventId, String actvScopeId, String eventScopeId, String activityId){
        this.eventId = eventId;
        this.actvScopeId = actvScopeId;
        this.eventScopeId = eventScopeId;
        this.activityId  = activityId;
        //this.activityName = activityName;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActvScopeId() {
        return actvScopeId;
    }

    public void setActvScopeId(String actvScopeId) {
        this.actvScopeId = actvScopeId;
    }

    public String getEventScopeId() {
        return eventScopeId;
    }

    public void setEventScopeId(String eventScopeId) {
        this.eventScopeId = eventScopeId;
    }
    
    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }
    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }
 
}