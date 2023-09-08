//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group					: Phoenix
// Product / Project		: Omniflow 8.1
// Module					: Transport Management System
// File Name				: WFTMSActivity.java
// Author					: Saurabh Kamal
// Date written (DD/MM/YYYY): 28/01/2010
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
public class WFTMSActivity {
	private String activityName;
	private int activityId;
	private int activityType;
	private int swimLaneId;
	private String swimLaneText;

	public WFTMSActivity(String activityName, int activityId, int activityType){
		this.activityName = activityName;
		this.activityId = activityId;
		this.activityType = activityType;
	}

	public WFTMSActivity(){		
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
	public int getActivityId() {
		return activityId;
	}

	public void setActivityId(int activityId) {
		this.activityId = activityId;
	}
	public int getActivityType() {
		return activityType;
	}

	public void setActivityType(int activityType) {
		this.activityType = activityType;
	}
	
	public int getSwimLaneId() {
		return swimLaneId;
	}

	public void setSwimLaneId(int swimLaneId) {
		this.swimLaneId = swimLaneId;
	}
	public String getSwimLaneText() {
		return swimLaneText;
	}

	public void setSwimLaneText(String swimLaneText) {
		this.swimLaneText = swimLaneText;
	}

}
