//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFMailTemplateUtil .java
//	Author					: Kumar Kimil
//	Date written (DD/MM/YYYY): 18/4/2017
//	Description				: 
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date				Change By			Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//20/04/2017        Kumar Kimil			Bug 66056-Support to send the Mail Notification when user diversion is set or removed
//
//----------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;


import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.File;
import java.io.FileInputStream;

import java.io.FileOutputStream;

import java.io.IOException;

import java.util.HashMap;

public class WFMailTemplateUtil {

    private static final WFMailTemplateUtil instance = new WFMailTemplateUtil();
    private final HashMap<Integer, String> templateMap = new HashMap<Integer, String>();
    private final String templateFolderPath;
    private final String templateName = "MailTemplate";
    private final String diversionTemplateName = "DiversionMailTemplate";
    private static String diversionTemplate = null;

    private WFMailTemplateUtil() {
        String configLocation = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
        if (configLocation == null || configLocation.equals("")) {
            configLocation = System.getProperty("user.dir");
        }
        if (!configLocation.endsWith(File.separator)) {
            configLocation += File.separator;
        }
        templateFolderPath = configLocation + "wfsConfig" + File.separator;
    }

    public static WFMailTemplateUtil getSharedInstance() {
        return instance;
    }

    public String getTemplate(int processDefId) {
        String template = templateMap.get(processDefId);
        if (template == null) {
            File templateFile = new File(templateFolderPath + templateName + "_" + processDefId + ".htm");
            if (!templateFile.exists()) {
                template = templateMap.get(0);
                //System.out.println("Inside getTemplate : template 2 " + template);
                if (template == null) {
                    templateFile = new File(templateFolderPath + templateName + ".htm");
                    if (templateFile.exists()) {
                        processDefId = 0;
                    }
                }
            }
            if (template == null) {
                template = readTemplateToBuffer(templateFile);
                templateMap.put(processDefId, template);
            }
        }
        return template;
    }

    public String readTemplateToBuffer(File templateFile) {
        StringBuilder template = new StringBuilder();
        FileInputStream fis =null;
        try {
            int size;
            byte[] buff = new byte[1024];
             fis = new FileInputStream(templateFile);
            while ((size = fis.read(buff)) > 0) {
                template.append(new String(buff, 0, size));
            }
        } catch (IOException ex) {
        }finally{
        	try{
        		if(fis!=null){
        			fis.close();
        			fis=null;
        		}
        	}catch(Exception e){
        		
        	}
        }
        return template.toString();
    }
    public String getTemplateForSetDiversionNotification() {
        if (diversionTemplate != null) {
            return diversionTemplate;
        }
        FileOutputStream fout =null;
        try {
            File templateFile = new File(templateFolderPath + diversionTemplateName + ".htm");
            if (!templateFile.exists()) {
                if (!templateFile.getParentFile().exists()) {
                    templateFile.getParentFile().mkdirs();
                }
                diversionTemplate = createDiversionMailTemplate();
                 fout = new FileOutputStream(templateFile);
                byte[] contentInBytes = diversionTemplate.getBytes();
                fout.write(contentInBytes);
                fout.flush();
                fout.close();
            } else {
                diversionTemplate = readTemplateToBuffer(templateFile);
            }
        } catch (Exception ex) {
        }finally{
        	try{
        		if(fout!=null){
        			fout.close();
        			fout=null;
        		}
        	}catch(Exception e){
        		
        	}
        }
        return diversionTemplate;
    }

    private String createDiversionMailTemplate() {
        StringBuilder diversionStr = new StringBuilder();
        diversionStr.append("<html>");
        diversionStr.append("<head>");
        diversionStr.append("<title>OmniFlow - User Diversion Notification</title>");
        diversionStr.append("<meta Data = \"<Subject>OmniFlow Diversion Notification - User Diversion &<Operation>& </Subject>\" >");
        diversionStr.append("<meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html;charset=<%=UTF-8%>\">");
        diversionStr.append("</head>");
        diversionStr.append("<body aLink=\"#008000\" background bgColor=\"#ffffff\" leftMargin=\"3\" link=\"#008000\" topMargin=\"0\" vLink=\"#008000\">");
        diversionStr.append("<table border=\"0\" cellSpacing=\"1\" width=\"100%\">");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"60%\"><h1><font face=\"arial\" color=\"green\">Newgen OmniFlow</font></h1></td>");
        diversionStr.append("<td vAlign=\"bottom\" width=\"40%\" align=\"left\"><font face=\"arial\" size=\"2\" color=\"blue\">");
        diversionStr.append("</font></td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td colSpan=\"2\" width=\"100%\"><hr align=\"left\"></td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td colSpan=\"2\" width=\"100%\" align=\"center\">");
        diversionStr.append("<table border=\"0\" cellSpacing=\"1\" width=\"100%\">");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"75%\" height=\"25\" align=\"left\">");
        diversionStr.append("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"75%\" valign=\"top\" align=\"left\" align=\"center\">");
        diversionStr.append("<table border=\"0\" cellspacing=\"1\" width=\"99%\">");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">Diversion Set For :</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<DivertedUser>& </font></td>");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">Assigned To User:</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<AssignedToUser>& </font></td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr Style = \"display : &<Display>&\">");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">From Date:</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<FromDate>& </font></td>");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">To Date:</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<ToDate>& </font></td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr Style = \"display : &<Display>&\">");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">AssignCurrentWorkItems :</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<AssignCurrentWorkItems>& </font></td>");
        diversionStr.append("<td width=\"20%\"><font color=\"#0000FF\" face=\"Arial\" size=\"2\">DivertBackAssignedWorkItems :</font></td>");
        diversionStr.append("<td width=\"30%\"><font color=\"#000000\" face=\"Arial\" size=\"2\"> &<DivertBackWorkItems>& </font></td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"100%\" colspan=\"4\"><span style=\"font-family: Arial; font-size: 8pt\"><font color=\"#0000FF\"></font></span></td>");
        diversionStr.append("</tr>");
        diversionStr.append("</table>");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("</table>");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td width=\"75%\" height=\"25\" bgcolor=\"#DBEEDE\" ><p><font size=\"2\" color=\"black\" face=\"arial\"><b>IMPORTANT :</b><strong> </strong></font>");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td height=\"27\"><font size=\"2\" color=\"black\" face=\"arial\">");
        diversionStr.append("<br>This is to inform that diversion has been &<Operation>& for the user &<DivertedUser>& </u></b></font><br><br>");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("</table>");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("<tr>");
        diversionStr.append("<td colSpan=\"2\" width=\"100%\"><hr align=\"left\">");
        diversionStr.append("</td>");
        diversionStr.append("</tr>");
        diversionStr.append("</table>");
        diversionStr.append("</form>");
        diversionStr.append("</body>");
        diversionStr.append("</html>");
        return diversionStr.toString();
    }
}


