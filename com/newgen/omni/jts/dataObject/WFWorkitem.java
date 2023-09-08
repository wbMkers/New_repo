package com.newgen.omni.jts.dataObject;

import java.sql.Connection;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

public class WFWorkitem {

  private String processInstanceId;
  private int workitemid;
  private int priority;
  private String processName;
  private int processDefId;
  private int lastProcessedBy;
  private String activityName;
  private int activityId;
  private java.sql.Timestamp entryDateTime;
  private int parentWorkItemId;
  private char assignmentType;
  private java.sql.Timestamp validTill;
  private int q_StreamId;
  private int q_QueueId;
  private int filterValue;
  private int q_UserId;
  private int createdby;
  private java.sql.Timestamp creationdatetime;
  private int workItemState;
  private java.sql.Timestamp expectedWorkitemDelay;

  public WFWorkitem(Connection con, String processInstance, int workitemid) {

  }

  public void setPriority(int priority) {
    this.priority = priority;
  }

  public int getPriority() {
    return priority;
  }

  public void setProcessName(String processName) {
    this.processName = processName;
  }

  public String getProcessName() {
    return processName;
  }

  public void setProcessDefId(int processDefId) {
    this.processDefId = processDefId;
  }

  public int getProcessDefId() {
    return processDefId;
  }

  public void setLastProcessedBy(int lastProcessedBy) {
    this.lastProcessedBy = lastProcessedBy;
  }

  public int getLastProcessedBy() {
    return lastProcessedBy;
  }

  public void setActivityName(String activityName) {
    this.activityName = activityName;
  }

  public String getActivityName() {
    return activityName;
  }

  public void setActivityId(int activityId) {
    this.activityId = activityId;
  }

  public int getActivityId() {
    return activityId;
  }

  public void setEntryDateTime(java.sql.Timestamp entryDateTime) {
    this.entryDateTime = entryDateTime;
  }

  public java.sql.Timestamp getEntryDateTime() {
    return entryDateTime;
  }

  public void setParentWorkItemId(int parentWorkItemId) {
    this.parentWorkItemId = parentWorkItemId;
  }

  public int getParentWorkItemId() {
    return parentWorkItemId;
  }

  public void setAssignmentType(char assignmentType) {
    this.assignmentType = assignmentType;
  }

  public char getAssignmentType() {
    return assignmentType;
  }

  public void setValidTill(java.sql.Timestamp validTill) {
    this.validTill = validTill;
  }

  public java.sql.Timestamp getValidTill() {
    return validTill;
  }

  public void setQ_StreamId(int q_StreamId) {
    this.q_StreamId = q_StreamId;
  }

  public int getQ_StreamId() {
    return q_StreamId;
  }

  public void setQ_QueueId(int q_QueueId) {
    this.q_QueueId = q_QueueId;
  }

  public int getQ_QueueId() {
    return q_QueueId;
  }

  public void setFilterValue(int filterValue) {
    this.filterValue = filterValue;
  }

  public int getFilterValue() {
    return filterValue;
  }

  public void setQ_UserId(int q_UserId) {
    this.q_UserId = q_UserId;
  }

  public int getQ_UserId() {
    return q_UserId;
  }

  public void setCreatedby(int createdby) {
    this.createdby = createdby;
  }

  public int getCreatedby() {
    return createdby;
  }

  public void setCreationdatetime(java.sql.Timestamp creationdatetime) {
    this.creationdatetime = creationdatetime;
  }

  public java.sql.Timestamp getCreationdatetime() {
    return creationdatetime;
  }

  public void setWorkItemState(int workItemState) {
    this.workItemState = workItemState;
  }

  public int getWorkItemState() {
    return workItemState;
  }

  public void setExpectedWorkitemDelay(java.sql.Timestamp expectedWorkitemDelay) {
    this.expectedWorkitemDelay = expectedWorkitemDelay;
  }

  public java.sql.Timestamp getExpectedWorkitemDelay() {
    return expectedWorkitemDelay;
  }
}