//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Phoenix
//	Product / Project			: OmniFlow
//	Module						: Transaction Server
//	File Name					: WFDuration.java
//	Author						: Ashish Mangla
//	Date written (DD/MM/YYYY)	: 27/11/2007
//	Description					: Structure for keeping the WFDuration data
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  25/11/2008                                   Shilpi S                   SrNo-1, Complex data type support in duration
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.excp.*;

public class WFDuration {

    private String years;
    private String VariableId_Years;
    private String VarFieldId_Years;
    private String months;
    private String VariableId_Months;
    private String VarFieldId_Months;
    private String days;
    private String VariableId_Days;
    private String VarFieldId_Days;
    private String hours;
    private String VariableId_Hours;
    private String VarFieldId_Hours;
    private String minutes;
    private String VariableId_Minutes;
    private String VarFieldId_Minutes;
    private String seconds;
    private String VariableId_Seconds;
    private String VarFieldId_Seconds;

    public WFDuration() {
    }

    public WFDuration(String xml) {
        XMLParser parser = new XMLParser(xml);
        try {
            years = parser.getValueOf("Years", "0", true);
            VariableId_Years = parser.getValueOf("VariableId_Years", "0", true);
            VarFieldId_Years = parser.getValueOf("VarFieldId_Years ", "0", true);
            
            months = parser.getValueOf("Months", "0", true);
            VariableId_Months = parser.getValueOf("VariableId_Months", "0", true);
            VarFieldId_Months = parser.getValueOf("VarFieldId_Months", "0", true);
            
            days = parser.getValueOf("Days", "0", true);
            VariableId_Days = parser.getValueOf("VariableId_Days", "0", true);
            VarFieldId_Days = parser.getValueOf("VarFieldId_Days", "0", true);
            
            hours = parser.getValueOf("Hours", "0", true);
            VariableId_Hours = parser.getValueOf("VariableId_Hours", "0", true);
            VarFieldId_Hours = parser.getValueOf("VarFieldId_Hours", "0", true);
            
            minutes = parser.getValueOf("Minutes", "0", true);
            VariableId_Minutes = parser.getValueOf("VariableId_Minutes", "0", true);
            VarFieldId_Minutes = parser.getValueOf("VarFieldId_Minutes", "0", true);
            
            seconds = parser.getValueOf("Seconds", "0", true);
            VariableId_Seconds = parser.getValueOf("VariableId_Seconds", "0", true);
            VarFieldId_Seconds = parser.getValueOf("VarFieldId_Seconds", "0", true);
        } catch (Exception e) {
            //e.printStackTrace();
        }
    }
    
    public WFDuration(String years, String months, String days, String hours, String minutes, String seconds) {
        this(years, "0", "0",
                months, "0", "0",
                days, "0", "0",
                hours, "0", "0",
                minutes, "0", "0",
                seconds, "0", "0");
    }
    
    public WFDuration(String VariableId_Years, String VarFieldId_Years, 
            String VariableId_Months, String VarFieldId_Months, 
            String VariableId_Days, String VarFieldId_Days, 
            String VariableId_Hours, String VarFieldId_Hours,  
            String VariableId_Minutes, String VarFieldId_Minutes, 
            String VariableId_Seconds, String VarFieldId_Seconds) {
        
        this("0", VariableId_Years, VarFieldId_Years, 
            "0", VariableId_Months, VarFieldId_Months, 
            "0", VariableId_Days, VarFieldId_Days, 
            "0", VariableId_Hours, VarFieldId_Hours,  
            "0", VariableId_Minutes, VarFieldId_Minutes, 
            "0", VariableId_Seconds, VarFieldId_Seconds);
    }
    
    public WFDuration(String years, String VariableId_Years, String VarFieldId_Years, 
            String months, String VariableId_Months, String VarFieldId_Months, 
            String days, String VariableId_Days, String VarFieldId_Days, 
            String hours, String VariableId_Hours, String VarFieldId_Hours,  
            String minutes, String VariableId_Minutes, String VarFieldId_Minutes, 
            String seconds, String VariableId_Seconds, String VarFieldId_Seconds) {
        
        this.years = years;
        this.VariableId_Years = VariableId_Years;
        this.VarFieldId_Years = VarFieldId_Years;
        
        this.months = months;
        this.VariableId_Months = VariableId_Months;
        this.VarFieldId_Months = VarFieldId_Months;
        
        this.days = days;
        this.VariableId_Days = VariableId_Days;
        this.VarFieldId_Days = VarFieldId_Days;
        
        this.hours = hours;
        this.VariableId_Hours = VariableId_Hours;
        this.VarFieldId_Hours = VarFieldId_Hours;
        
        this.minutes = minutes;
        this.VariableId_Minutes = VariableId_Minutes;
        this.VarFieldId_Minutes = VarFieldId_Minutes;
        
        this.seconds = seconds;
        this.VariableId_Seconds = VariableId_Seconds;
        this.VarFieldId_Seconds = VarFieldId_Seconds;
        
    }
    
    
    public void setYears(String years) {
        this.years = years;
    }

    public String getYears() {
        return years;
    }

    public void setMonths(String months) {
        this.months = months;
    }

    public String getMonths() {
        return months;
    }

    public void setDays(String days) {
        this.days = days;
    }

    public String getDays() {
        return days;
    }

    public void setHours(String hours) {
        this.hours = hours;
    }

    public String getHours() {
        return hours;
    }

    public void setMinutes(String minutes) {
        this.minutes = minutes;
    }

    public String getMinutes() {
        return minutes;
    }

    public void setSeconds(String seconds) {
        this.seconds = seconds;
    }

    public String getSeconds() {
        return seconds;
    }

    public String getVarFieldId_Days() {
        return VarFieldId_Days;
    }

    public void setVarFieldId_Days(String VarFieldId_Days) {
        this.VarFieldId_Days = VarFieldId_Days;
    }

    public String getVarFieldId_Hours() {
        return VarFieldId_Hours;
    }

    public void setVarFieldId_Hours(String VarFieldId_Hours) {
        this.VarFieldId_Hours = VarFieldId_Hours;
    }

    public String getVarFieldId_Minutes() {
        return VarFieldId_Minutes;
    }

    public void setVarFieldId_Minutes(String VarFieldId_Minutes) {
        this.VarFieldId_Minutes = VarFieldId_Minutes;
    }

    public String getVarFieldId_Months() {
        return VarFieldId_Months;
    }

    public void setVarFieldId_Months(String VarFieldId_Months) {
        this.VarFieldId_Months = VarFieldId_Months;
    }

    public String getVarFieldId_Seconds() {
        return VarFieldId_Seconds;
    }

    public void setVarFieldId_Seconds(String VarFieldId_Seconds) {
        this.VarFieldId_Seconds = VarFieldId_Seconds;
    }

    public String getVarFieldId_Years() {
        return VarFieldId_Years;
    }

    public void setVarFieldId_Years(String VarFieldId_Years) {
        this.VarFieldId_Years = VarFieldId_Years;
    }

    public String getVariableId_Days() {
        return VariableId_Days;
    }

    public void setVariableId_Days(String VariableId_Days) {
        this.VariableId_Days = VariableId_Days;
    }

    public String getVariableId_Hours() {
        return VariableId_Hours;
    }

    public void setVariableId_Hours(String VariableId_Hours) {
        this.VariableId_Hours = VariableId_Hours;
    }

    public String getVariableId_Minutes() {
        return VariableId_Minutes;
    }

    public void setVariableId_Minutes(String VariableId_Minutes) {
        this.VariableId_Minutes = VariableId_Minutes;
    }

    public String getVariableId_Months() {
        return VariableId_Months;
    }

    public void setVariableId_Months(String VariableId_Months) {
        this.VariableId_Months = VariableId_Months;
    }

    public String getVariableId_Seconds() {
        return VariableId_Seconds;
    }

    public void setVariableId_Seconds(String VariableId_Seconds) {
        this.VariableId_Seconds = VariableId_Seconds;
    }

    public String getVariableId_Years() {
        return VariableId_Years;
    }

    public void setVariableId_Years(String VariableId_Years) {
        this.VariableId_Years = VariableId_Years;
    }

    public String toString() {
        StringBuffer durationXML = new StringBuffer();
        XMLGenerator gen = new XMLGenerator();

        durationXML.append(gen.writeValueOf("Years", years));
        durationXML.append(gen.writeValueOf("VariableId_Years", VariableId_Years));
        durationXML.append(gen.writeValueOf("VarFieldId_Years", VarFieldId_Years));
        
        durationXML.append(gen.writeValueOf("Months", months));
        durationXML.append(gen.writeValueOf("VariableId_Months", VariableId_Months));
        durationXML.append(gen.writeValueOf("VarFieldId_Months", VarFieldId_Months));
        
        durationXML.append(gen.writeValueOf("Days", days));
        durationXML.append(gen.writeValueOf("VariableId_Days", VariableId_Days));
        durationXML.append(gen.writeValueOf("VarFieldId_Days", VarFieldId_Days));
        
        durationXML.append(gen.writeValueOf("Hours", hours));
        durationXML.append(gen.writeValueOf("VariableId_Hours", VariableId_Hours));
        durationXML.append(gen.writeValueOf("VarFieldId_Hours", VarFieldId_Hours));
        
        durationXML.append(gen.writeValueOf("Minutes", minutes));
        durationXML.append(gen.writeValueOf("VariableId_Minutes", VariableId_Minutes));
        durationXML.append(gen.writeValueOf("VarFieldId_Minutes", VarFieldId_Minutes));
        
        durationXML.append(gen.writeValueOf("Seconds", seconds));
        durationXML.append(gen.writeValueOf("VariableId_Seconds", VariableId_Seconds));
        durationXML.append(gen.writeValueOf("VarFieldId_Seconds", VarFieldId_Seconds));

        return durationXML.toString();
    }
    
    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	getXMLForHistory
    //	Author						:	Ashish Mangla
    //  Date						:	16/12/2008
    //	Input Parameters			:	None
    //	Output Parameters			:   None
    //	Return Values				:	XML
    //	Description					:   XML to be used in gen admin log
    //----------------------------------------------------------------------------------------------------
	public String getXMLForHistory() {
        StringBuffer durationXML = new StringBuffer();
        XMLGenerator gen = new XMLGenerator();

        durationXML.append(gen.writeValueOf("Years", years));
        durationXML.append(gen.writeValueOf("Months", months));
        durationXML.append(gen.writeValueOf("Days", days));
        durationXML.append(gen.writeValueOf("Hours", hours));
        durationXML.append(gen.writeValueOf("Minutes", minutes));
        durationXML.append(gen.writeValueOf("Seconds", seconds));
        return durationXML.toString();
    }
}