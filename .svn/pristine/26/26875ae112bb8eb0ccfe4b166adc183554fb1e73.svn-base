package com.newgen.omni.healthmonitoring.analyze.log;


public class Record {

    private int entityType, subEntityType, severity;
    private String processName, activityName, QueueName, field1, field2, field3, field4, field5, description, impact, recommendation, observation;

    public Record(int entityType, int subEntityType, String field1, String field2, String description, int severity, String field3, String impact, String recommendation, String field4, String field5, String processName, String activityName, String queueName, String observation) {
        this.entityType = entityType;
        this.subEntityType = subEntityType;
        this.field1 = field1;
        this.field2 = field2;
        this.description = description;
        this.severity = severity;
        this.field3 = field3;
        this.impact = impact;
        this.recommendation = recommendation;
        this.field4 = field4;
        this.field5 = field5;
        this.processName = processName;
        this.activityName = activityName;
        this.QueueName = queueName;
        this.observation = observation;
    }

    public String getObservation() {
        return observation;
    }

    public void setObservation(String observation) {
        this.observation = observation;
    }

    public String getProcessName() {
        return processName;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getQueueName() {
        return QueueName;
    }

    public void setQueueName(String QueueName) {
        this.QueueName = QueueName;
    }

    public String getField4() {
        return field4;
    }

    public void setField4(String field4) {
        this.field4 = field4;
    }

    public String getField5() {
        return field5;
    }

    public void setField5(String field5) {
        this.field5 = field5;
    }

    public String getField3() {
        return field3;
    }

    public void setField3(String field3) {
        this.field3 = field3;
    }

    public String getImpact() {
        return impact;
    }

    public void setImpact(String impact) {
        this.impact = impact;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public Record() {

    }

    public int getEntityType() {
        return entityType;
    }

    public int getSubEntityType() {
        return subEntityType;
    }

    public String getField1() {
        return field1;
    }

    public String getField2() {
        return field2;
    }

    public String getDescription() {
        return description;
    }

    public int getSeverity() {
        return severity;
    }

    public String getSeverityString(int data) {
        String stringSeverity = null;
        switch (data) {
            case 0:
                stringSeverity = "LOW";
                break;
            case 1:
                stringSeverity = "MEDIUM";
                break;
            case 2:
                stringSeverity = "HIGH";
                break;
            case 3:
                stringSeverity = "CRITICAL";
                break;
            default:
                break;
        }
        return stringSeverity;
    }

    @Override
    public String toString() {
        return (entityType + "  " + subEntityType + " " + field1 + " " + field2 + " " + description + " " + severity);
    }
}
