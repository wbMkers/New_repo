// ----------------------------------------------------------------------------------------------------
// NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group : Application-Products
// Product / Project : WorkFlow
// Module : iBPS Server
// File Name : WFTaskReassignedEmailNotification.java
// Author : Ambuj Tripathi
// Date written (DD/MM/YYYY): 06/07/2017
// Description : Utility Class written for Case management to send email notification in case task is reassigned.
// ----------------------------------------------------------------------------------------------------
// CHANGE HISTORY
// ----------------------------------------------------------------------------------------------------
// Date Change By Change Description (Bug No. (If Any))
//28/07/2017		Ambuj Tripathi      	Added the changes for the task expiry feature for Case Management
// ------------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Properties;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

public class WFTaskReassignedEmailNotification {
	private static WFConfigLocator configLocator = WFConfigLocator.getInstance();
	private static String configPath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator
			+ WFSConstant.CONST_DIRECTORY_CONFIG;
	private static Properties taskReassignedEmailNotificationProperties = new Properties();
	private static String strMailFrom = "";
	private static String strMailSubject = "";
	public static final StringBuffer taskReassignedTemplateHTML = null;

/*	*//***
	 * Method Name : addTaskToMailQueue
	 * @param con
	 * @param dbType
	 * @param attributesForTask
	 * @param processdefid
	 * @param mailTo
	 * @param processInstanceId
	 * @param workItemId
	 * @param activityId
	 * @throws WFSException
	 * @author ambuj.tripathi
	 *//*
	public static void addTaskToMailQueue(Connection con, int dbType, HashMap<String, String> attributesForTask,
			int processdefid, String mailTo, String processInstanceId, int workItemId, int activityId)
			throws WFSException {
		//check if mail need to be send.
		String cabinetName = attributesForTask.get("CabinetName");
		if(EmailTemplateUtil.isToSendEmail("ReassignTask", cabinetName, processdefid)){				
			PreparedStatement pstmt = null;
			int mainCode = 0;
			int subCode = 0;
			String subject = null;
			String descr = null;
			String errType = WFSError.WF_TMP;
			try {
				String strContentType = "text/html";
				String propertyNameToFetchEmailConfigurations = "ReassignTask"+ WFSConstant.Underscore+Locale.getDefault().toString();
				String reassignTaskTemplate = EmailTemplateUtil.retrieveEmailTemplate(propertyNameToFetchEmailConfigurations, cabinetName, processdefid);
				String mailMessage = EmailTemplateUtil.searchAndReplaceAttributes(reassignTaskTemplate, attributesForTask);
				Properties emailProperties = EmailTemplateUtil.retrieveEmailProperties(propertyNameToFetchEmailConfigurations, cabinetName, processdefid);
				String mailFrom = (String) emailProperties.get("EmailFrom");
				String mailSubject = EmailTemplateUtil.searchAndReplaceAttributes((String) emailProperties.get("EmailSubject"), attributesForTask);
				int iPriority = 1;
				String strComments = null;
				String strMailActionType = "TaskNotification";
				String strAgentName = mailFrom;
				String strSQL = "INSERT INTO WFMailQueueTable (mailFrom, mailTo, mailCC, mailSubject, mailMessage, "
						+ "mailContentType, attachmentISINDEX, attachmentNames, mailPriority, mailStatus, statusComments, "
						+ "insertedTime, insertedBy, mailActionType, processDefId, processInstanceId, workitemId, activityId, "
						+ "attachmentExts, noOfTrials ) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?," + WFSUtil.getDate(dbType)
						+ ", ?, ?, ?, ?, ?, ?, ?, ?) ";
				pstmt = con.prepareStatement(strSQL);
				WFSUtil.DB_SetString(1, mailFrom, pstmt, dbType);
				WFSUtil.DB_SetString(2, mailTo, pstmt, dbType);
				WFSUtil.DB_SetString(3, null, pstmt, dbType);
				WFSUtil.DB_SetString(4, mailSubject, pstmt, dbType);
				pstmt.setCharacterStream(5, new java.io.StringReader(mailMessage), mailMessage.length());
				WFSUtil.DB_SetString(6, strContentType, pstmt, dbType);
				WFSUtil.DB_SetString(7, null, pstmt, dbType);
				WFSUtil.DB_SetString(8, null, pstmt, dbType);
				pstmt.setInt(9, iPriority);
				WFSUtil.DB_SetString(10, "N", pstmt, dbType);
				WFSUtil.DB_SetString(11, strComments, pstmt, dbType);
				WFSUtil.DB_SetString(12, strAgentName, pstmt, dbType);
				WFSUtil.DB_SetString(13, strMailActionType, pstmt, dbType);
				pstmt.setInt(14, processdefid);
				WFSUtil.DB_SetString(15, processInstanceId, pstmt, dbType);
				pstmt.setInt(16, workItemId);
				pstmt.setInt(17, activityId);
				WFSUtil.DB_SetString(18, null, pstmt, dbType);
				pstmt.setInt(19, 3);
				pstmt.execute();
				pstmt.close();
				pstmt = null;
	
			} catch (SQLException e) {
				WFSUtil.printErr("", e);
				mainCode = WFSError.WM_INVALID_FILTER;
				subCode = WFSError.WFS_SQL;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_FAT;
				if (e.getErrorCode() == 0) {
					if (e.getSQLState().equalsIgnoreCase("08S01"))
						descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
				if (mainCode != 0)
					throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
	}
	
*/	/**
	 * This function is added as Overloaded method to support the Task Expiry feature
	 * @param fromUserValue
	 * @param toUserValue
	 * @param ccUserValue
	 * @param bccUserValue
	 * @param mailPriorityValue
	 * @param mailSubject
	 * @param mailMessage
	 * @param con
	 * @param dbType
	 * @param mapForTaskAttributes
	 * @param processDefId
	 * @param processInstanceId
	 * @param workItemId
	 * @param activityId
	 * @throws WFSException
	 */
	public static void addTaskToMailQueue(String fromUserValue, String toUserValue, String ccUserValue, String bccUserValue, int mailPriorityValue, 
			String mailSubject, String mailMessage, Connection con, int dbType, HashMap<String, String> mapForTaskAttributes, int processDefId, 
			String processInstanceId, int workItemId, int activityId) throws WFSException {
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		try {
			String strContentType = "text/html";
			String strComments = null;
			String strMailActionType = "TaskNotification";
			String strAgentName = fromUserValue;
			String strSQL = "INSERT INTO WFMailQueueTable (mailFrom, mailTo, mailCC, mailBCC, mailSubject, mailMessage, "
					+ "mailContentType, attachmentISINDEX, attachmentNames, mailPriority, mailStatus, statusComments, "
					+ "insertedTime, insertedBy, mailActionType, processDefId, processInstanceId, workitemId, activityId, "
					+ "attachmentExts, noOfTrials ) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?," + WFSUtil.getDate(dbType)
					+ ", ?, ?, ?, ?, ?, ?, ?, ?) ";
			pstmt = con.prepareStatement(strSQL);
			WFSUtil.DB_SetString(1, fromUserValue, pstmt, dbType);
			WFSUtil.DB_SetString(2, toUserValue, pstmt, dbType);
			WFSUtil.DB_SetString(3, ccUserValue, pstmt, dbType);
			WFSUtil.DB_SetString(4, bccUserValue, pstmt, dbType);
			WFSUtil.DB_SetString(5, mailSubject, pstmt, dbType);
			pstmt.setCharacterStream(6, new java.io.StringReader(mailMessage), mailMessage.length());
			WFSUtil.DB_SetString(7, strContentType, pstmt, dbType);
			WFSUtil.DB_SetString(8, null, pstmt, dbType);
			WFSUtil.DB_SetString(9, null, pstmt, dbType);
			pstmt.setInt(10, mailPriorityValue);
			WFSUtil.DB_SetString(11, "N", pstmt, dbType);
			WFSUtil.DB_SetString(12, strComments, pstmt, dbType);
			WFSUtil.DB_SetString(13, strAgentName, pstmt, dbType);
			WFSUtil.DB_SetString(14, strMailActionType, pstmt, dbType);
			pstmt.setInt(15, processDefId);
			WFSUtil.DB_SetString(16, processInstanceId, pstmt, dbType);
			pstmt.setInt(17, workItemId);
			pstmt.setInt(18, activityId);
			WFSUtil.DB_SetString(19, null, pstmt, dbType);
			pstmt.setInt(20, 3);
			pstmt.execute();
			pstmt.close();
			pstmt = null;

		} catch (SQLException e) {
			WFSUtil.printErr("", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if (e.getErrorCode() == 0) {
				if (e.getSQLState().equalsIgnoreCase("08S01"))
					descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
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
			throw new WFSException(mainCode, subCode, errType, subject, descr);
	}
}
