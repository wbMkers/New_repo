/*------------------------------------------------------------------------------------------------------------
      NEWGEN SOFTWARE TECHNOLOGIES LIMITED
        Group        :       Genesis
        Product      :       iBPS
        Module       :       iBPS Server
        File Name    :       EmailTemplateUtil.java
        Author       :       Shubhankur Manuja
        Date written :       18/09/2017
        Description  :       Utility class to load email templates process wise.
--------------------------------------------------------------------------------------------------------------
                            CHANGE HISTORY
--------------------------------------------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)
31/10/2017		Ambuj Tripathi	Bug#WBL+Oracle: Due date & instruction is not coming in received mail's mail body
//09/11/2021	Aqsa hashmi		Bug 102363 , bug 102366- Unable to complete and reassign task getting error due to when locale is set other than en_US
--------------------------------------------------------------------------------------------------------------*/


package com.newgen.omni.jts.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Properties;

import org.apache.commons.io.FilenameUtils;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;


/**
 * @author shubhankur.manuja
 *
 */
public class EmailTemplateUtil {

	private static HashMap<String, StringBuffer> emailTemplateMap = new HashMap<String, StringBuffer>();
	private static HashMap<String, Properties> emailPropertiesMap = new HashMap<String, Properties>();
	private static final String PROPERTIES_EXT = "PROPERTIES";
	private static final String baseEmailTemplateConfigFolder = "EmailTemplateConfig";
	private static String baseEmailTemplateConfigDir = "";
	private static Properties emailPropertiesFileBuffer = new Properties();
	private static StringBuffer emailTemplateFileBuffer = new StringBuffer();
	
	static {
		try {
			load();
			} 
		catch (Exception e) {
			//System.out.println(e);
			}
		}

	private static void load() {
		baseEmailTemplateConfigDir = retrieveEmailTemplateConfigBaseDir();
		loadAllTemplatesToMap();
	    }

	private static void loadAllTemplatesToMap() {
		File baseEmailTemplateConfigDirFileObj = new File(baseEmailTemplateConfigDir);
		String[] baseEmailTemplateConfigDirFilesList = baseEmailTemplateConfigDirFileObj.list();
		String[] dirName = new String[2];
		String cabinetName = "";
		String processDefId = "";
		for(String name : baseEmailTemplateConfigDirFilesList)
		{
		    if (new File(baseEmailTemplateConfigDir + name).isDirectory())
		    {
		    	dirName = name.split(WFSConstant.Underscore);
		        cabinetName = dirName[0];
		        processDefId = dirName[1];
		        loadCustomizedTemplatesAndConfigIntoMap(baseEmailTemplateConfigDir + name + File.separator, cabinetName, processDefId);
		    }
		    else{
		    	loadDefaultTemplatesAndConfigIntoMap(name);
		    }
		}
		
	}

	private static void loadCustomizedTemplatesAndConfigIntoMap(String customizedDirectory, String cabinetName, String processDefId) {
		File customizedDirectoryObj = new File(customizedDirectory);
		for(String name : customizedDirectoryObj.list())
		{
			if(PROPERTIES_EXT.equalsIgnoreCase(FilenameUtils.getExtension(name))){
				loadEmailPropertiesFile(name, customizedDirectory);
				emailPropertiesMap.put(name+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+processDefId, emailPropertiesFileBuffer);
			}
			else{
				loadTemplateToBuffer(name, customizedDirectory);
				emailTemplateMap.put(name+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+processDefId, emailTemplateFileBuffer);
			}
		}
		 
	}

	/**
	 * @param name
	 */
	private static void loadEmailPropertiesFile(String name, String directory) {
		try {
			emailPropertiesFileBuffer = new Properties();
			emailPropertiesFileBuffer.load(new FileInputStream(directory+name));
		} catch (Exception e){
			WFSUtil.printErr("","Error in reading " + name + " file.", e);
		}
	}

	private static void loadDefaultTemplatesAndConfigIntoMap(String name) {
		
		if(PROPERTIES_EXT.equalsIgnoreCase(FilenameUtils.getExtension(name))){
			loadEmailPropertiesFile(name, baseEmailTemplateConfigDir);
			emailPropertiesMap.put(name, emailPropertiesFileBuffer);
		}
		else{
			loadTemplateToBuffer(name, baseEmailTemplateConfigDir);
			emailTemplateMap.put(name, emailTemplateFileBuffer);
		}
		
	}

	private static void loadTemplateToBuffer(String templateFileName, String directory) {
		BufferedReader br = null;
		try {
			String str;
			
			emailTemplateFileBuffer = new StringBuffer();
			 br = new BufferedReader(new FileReader(directory+templateFileName));
			do {
				str = br.readLine();
				if (str != null)
					emailTemplateFileBuffer.append(str);

			} while (str != null);
			br.close();
			br = null;
		}catch (Exception e) { 
			WFSUtil.printErr("","Error in reading " + templateFileName + " file.", e);
		}
		
		finally{
			
			try {
	            if (br != null) {
	                br.close();
	                br = null;
	            }
	        } catch (Exception sqle) {
	        }
		}
	}

	/**
	 * @return 
	 * 
	 */
	private static String retrieveEmailTemplateConfigBaseDir() {
		String templateFolderPath= "";
		String configLocation = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
	        if (configLocation == null || configLocation.equals("")) {
	            configLocation = System.getProperty("user.dir");
	        }
	        if (!configLocation.endsWith(File.separator)) {
	            configLocation += File.separator;
	        }
	        configLocation=FilenameUtils.normalize(configLocation);
	        templateFolderPath = configLocation + "wfsconfig" + File.separator + baseEmailTemplateConfigFolder + File.separator;
	        return templateFolderPath;
	}
	
	public static HashMap<String, StringBuffer> getEmailTemplateMap() {
		return emailTemplateMap;
	}

	public static void setEmailTemplateMap(
			HashMap<String, StringBuffer> emailTemplateMap) {
		EmailTemplateUtil.emailTemplateMap = emailTemplateMap;
	}

	public static HashMap<String, Properties> getEmailPropertiesMap() {
		return emailPropertiesMap;
	}

	public static void setEmailPropertiesMap(
			HashMap<String, Properties> emailPropertiesMap) {
		EmailTemplateUtil.emailPropertiesMap = emailPropertiesMap;
	}
	
	public static boolean isToSendEmail(String property, String cabinetName, int processDefId){
		
		String emailConfig = "EmailConfig.properties";
		Properties EmailConfigProperties = (emailPropertiesMap.get(emailConfig+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId))!=null) ? 
				emailPropertiesMap.get(emailConfig+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId)) : emailPropertiesMap.get(emailConfig);
		boolean isToSendEmail = "Y".equalsIgnoreCase(((String) EmailConfigProperties.get(property))) ? true : false;
		return isToSendEmail;
	}

	public static String retrieveEmailTemplate(String property, String cabinetName, int processDefId){
		
		String templateExtension = ".htm";
		StringBuffer templateBuffer = (emailTemplateMap.get(property+templateExtension+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId))!=null) ? 
				emailTemplateMap.get(property+templateExtension+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId)) : emailTemplateMap.get(property+templateExtension);
				if(templateBuffer == null){
					property= property.substring(0,property.indexOf("_"))+"_en_US";
					templateBuffer=(emailTemplateMap.get(property+templateExtension+"_"+cabinetName+"_"+Integer.toString(processDefId))!=null) ? 
							emailTemplateMap.get(property+templateExtension+"_"+cabinetName+"_"+Integer.toString(processDefId)) : emailTemplateMap.get(property+templateExtension);
				}
				return templateBuffer.toString();
	}
	
	public static Properties retrieveEmailProperties(String property, String cabinetName, int processDefId){
		String propertiesExtension = ".properties";
		Properties emailProperties = (emailPropertiesMap.get(property+propertiesExtension+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId))!=null) ? 
				emailPropertiesMap.get(property+propertiesExtension+WFSConstant.Underscore+cabinetName+WFSConstant.Underscore+Integer.toString(processDefId)) : emailPropertiesMap.get(property+propertiesExtension);
				if(emailProperties == null){
		        	property= property.substring(0,property.indexOf("_"))+"_en_US";
		        	emailProperties = (emailPropertiesMap.get(property+propertiesExtension+"_"+cabinetName+"_"+Integer.toString(processDefId))!=null) ? 
		    				emailPropertiesMap.get(property+propertiesExtension+"_"+cabinetName+"_"+Integer.toString(processDefId)) : emailPropertiesMap.get(property+propertiesExtension);
		        }
				return emailProperties;
	}
	
	public static String searchAndReplaceAttributes(String templateHTML,
				HashMap<String, String> attributesForTask) {
			
			Iterator<String> itr = attributesForTask.keySet().iterator();
			while (itr.hasNext()) {
		        String attributeName = (String) itr.next();
		        String attributeValue = (String)attributesForTask.get(attributeName);
		        if(attributeValue == null || attributeValue.isEmpty() || "NULL".equalsIgnoreCase(attributeValue)){
		        	attributeValue = "";
		        }
		        attributeName="&<"+attributeName+">&";
		        templateHTML= WFSUtil.replace(templateHTML,attributeName,attributeValue);
			}    
		        
			return templateHTML;
	}
	
	public static void addTaskToMailQueue(Connection con, HashMap<String, String> mailTemplateAttributes, HashMap<String, Integer> mailIntAttributes,  HashMap<String, String> mailStringAttributes) throws WFSException {

		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		PreparedStatement pstmt = null;
		try {
			String cabinetName = mailStringAttributes.get("CabinetName");
			String mailTo = mailStringAttributes.get("MailTo");
			String mailCC = mailStringAttributes.get("MailCC");
			String mailAttachmentIndex = mailStringAttributes.get("MailAttachmentIndex");
			String mailAttachmentNames = mailStringAttributes.get("MailAttachmentNames");
			String mailStatus = mailStringAttributes.get("MailStatus");
			String mailStatusComments = mailStringAttributes.get("MailStatusComments");
			String mailInsertedBy = mailStringAttributes.get("MailInsertedBy");
			String mailActionType = mailStringAttributes.get("MailActionType");
			String mailAttachmentExtensions = mailStringAttributes.get("MailAttachmentExtensions");
			String propertyName = mailStringAttributes.get("PropertyName");
			String processInstanceId = mailStringAttributes.get("ProcessInstanceId");
			int processDefID = mailIntAttributes.get("ProcessDefID");
			int workItemId = mailIntAttributes.get("WorkItemId");
			int activityId = mailIntAttributes.get("ActivityId");
			int dbType = mailIntAttributes.get("DbType");
			int mailPriority = mailIntAttributes.get("MailPriority");
			int noOfTrials =  mailIntAttributes.get("NoOfTrials");
			//check if mail need to be send.
			if(isToSendEmail(propertyName, cabinetName, processDefID)){
					String strContentType = "text/html";
					String propertyNameToFetchEmailConfigurations = propertyName+ WFSConstant.Underscore+Locale.getDefault().toString();
					String taskTemplate = retrieveEmailTemplate(propertyNameToFetchEmailConfigurations, cabinetName, processDefID);
					String mailMessage = EmailTemplateUtil
							.searchAndReplaceAttributes(
									taskTemplate,
									mailTemplateAttributes);
					Properties emailProperties = retrieveEmailProperties(propertyNameToFetchEmailConfigurations, cabinetName, processDefID);
					String mailFrom = (String) emailProperties.get("EmailFrom");
					String mailSubject = searchAndReplaceAttributes((String) emailProperties.get("EmailSubject"), mailTemplateAttributes);
					String strSQL = "INSERT INTO WFMailQueueTable (mailFrom, mailTo, mailCC, mailSubject, mailMessage, "
							+ "mailContentType, attachmentISINDEX, attachmentNames, mailPriority, mailStatus, statusComments, "
							+ "insertedTime, insertedBy, mailActionType, processDefId, processInstanceId, workitemId, activityId, "
							+ "attachmentExts, noOfTrials ) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"
							+ WFSUtil.getDate(dbType) + ", ?, ?, ?, ?, ?, ?, ?, ?) ";
					pstmt = con.prepareStatement(strSQL);
					WFSUtil.DB_SetString(1, mailFrom, pstmt, dbType);
					WFSUtil.DB_SetString(2, mailTo, pstmt, dbType);
					WFSUtil.DB_SetString(3, mailCC, pstmt, dbType);
					WFSUtil.DB_SetString(4, mailSubject, pstmt, dbType);
					pstmt.setCharacterStream(5, new java.io.StringReader(mailMessage),
							mailMessage.length());
					WFSUtil.DB_SetString(6, strContentType, pstmt, dbType);
					WFSUtil.DB_SetString(7, mailAttachmentIndex, pstmt, dbType);
					WFSUtil.DB_SetString(8, mailAttachmentNames, pstmt, dbType);
					pstmt.setInt(9, mailPriority);
					WFSUtil.DB_SetString(10, mailStatus, pstmt, dbType);
					WFSUtil.DB_SetString(11, mailStatusComments, pstmt, dbType);
					WFSUtil.DB_SetString(12, mailInsertedBy, pstmt, dbType);
					WFSUtil.DB_SetString(13, mailActionType, pstmt, dbType);
					pstmt.setInt(14, processDefID);
					WFSUtil.DB_SetString(15, processInstanceId, pstmt, dbType);
					pstmt.setInt(16, workItemId);
					pstmt.setInt(17, activityId);
					WFSUtil.DB_SetString(18, mailAttachmentExtensions, pstmt, dbType);
					pstmt.setInt(19, noOfTrials);
					pstmt.execute();
					pstmt.close();
					pstmt = null;			
				}
		
			} catch (SQLException e) {
				WFSUtil.printErr("", e);
				mainCode = WFSError.WM_INVALID_FILTER;
				subCode = WFSError.WFS_SQL;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_FAT;
				if (e.getErrorCode() == 0) {
					if (e.getSQLState().equalsIgnoreCase("08S01"))
						descr = (new JTSSQLError(e.getSQLState())).getMessage()
								+ "(SQL State : " + e.getSQLState() + ")";
				} else
					descr = e.getMessage();
			} catch (Exception e) {
				WFSUtil.printErr("", e);
				mainCode = WFSError.WF_OPERATION_FAILED;
				subCode = WFSError.WFS_EXP;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_TMP;
				descr = e.toString();
			} catch (Error e) {
				WFSUtil.printErr("", e);
				mainCode = WFSError.WF_OPERATION_FAILED;
				subCode = WFSError.WFS_EXP;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_TMP;
				descr = e.toString();
			} finally {
				try {
					if (pstmt != null) {
						pstmt.close();
						pstmt = null;
					}
				} catch (Exception e) {
				}
				
			}
			if (mainCode != 0)
				throw new WFSException(mainCode, subCode, errType, subject,
						descr);

		}
	
		
	}

