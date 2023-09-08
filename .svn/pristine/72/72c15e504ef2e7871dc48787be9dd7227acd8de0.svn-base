//-------------------------------------------------------------------------
//				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//		Group						: Application �Products 
//		Product / Project			: Omni Flow 6.1
//		Module						: Workflow Server
//		File Name					: WFCustomBean.java	
//		Author						: Mandeep Kaur
//		Date written (DD/MM/YYYY)	: 30/08/2005
//		Description					: WFCustom bean to write custom code.
//-------------------------------------------------------------------------
//					CHANGE HISTORY
//-------------------------------------------------------------------------
//	Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-------------------------------------------------------------------------
// 03/06/2013           Kahkeshan       Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
//-------------------------------------------------------------------------

package com.newgen.omni.jts.txn.cust;
import com.newgen.omni.jts.txn.*;
import java.sql.*;
import java.util.*;

import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import java.sql.Connection;
import java.sql.Statement;
import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.constt.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.*;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import java.io.*;
import nu.xom.*;
import java.security.MessageDigest;

public class WFCustomBean extends com.newgen.omni.jts.txn.NGOServerInterface{

		private static String _strFilepath = "."+File.separatorChar+"OFWeb_logs"+File.separatorChar+"FBD_DBLink.log"; 
		public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,WFSException {
		String option = parser.getValueOf("Option", "", false);
		String outputXml = null;
		if(option.equals("REPLACE_WITH_NAME_OF_API")){
			outputXml = "";
		} 
		else if (option.equals("IGGetData"))
        {
            outputXml = getData(con, parser, gen);
        }
        else if (option.equals("IGSetData"))
        {
            outputXml = setData(con, parser, gen);
        }
		else{
			outputXml = gen.writeError("WFCustom", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
			WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
		}
		return outputXml;
	}
	
	public String getData(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException
    {
        StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = "";
        try
        {
            engine = parser.getValueOf("EngineName",engine);
            XMLReader xerces = XMLReaderFactory.createXMLReader(); 
            Builder objBuilder = new Builder(xerces,false);
           // Builder objBuilder = new Builder();
            Document docInput = objBuilder.build(new StringReader(parser.toString()));
            Element rootNode = docInput.getRootElement();

            LogFilenew("****** GetData ******",engine);

            int iSessionId = Integer.parseInt(rootNode.getFirstChildElement("SessionId").getValue());
            if (WFSUtil.WFCheckSession(con, iSessionId) == null)
            {
                mainCode = -1;
                subCode = -1;
                subject = "Invalid session.";
                descr = "Invalid session.";
                Element nodeOutXml = new Element("IGGetData_Output");
                Element nodeExp = new Element("Exception");
                nodeOutXml.appendChild(nodeExp);
                Element node = new Element("MainCode");
                node.appendChild("-1");
                nodeExp.appendChild(node);

                node = new Element("TypeOfError");
                node.appendChild("TEMPORARY");
                nodeExp.appendChild(node);

                node = new Element("Subject");
                node.appendChild("Invalid session.");
                nodeExp.appendChild(node);
                outputXML = new StringBuffer(nodeOutXml.toXML());
            }
            else
            {
                Element nodeQuery = rootNode.getFirstChildElement("QueryString");
                String queryString = nodeQuery.getValue();
                queryString = WFSUtil.TO_SANITIZE_STRING(queryString, true);
                LogFilenew("Input Query:" + queryString,engine);

                int iCheckSum = Integer.parseInt(nodeQuery.getAttributeValue("CS"));
                if (validateCheckSum(queryString, iSessionId, iCheckSum,engine))
                {
                    if (queryString.trim().toUpperCase().startsWith("CALL "))
                    {
                        stmt = con.prepareCall("{" + queryString + "}");
                        CallableStatement cstmt = (CallableStatement) stmt;
                        cstmt.registerOutParameter(1, -10);
                        cstmt.execute();
                        rs = (ResultSet) cstmt.getObject(1);
                    }
                    else
                    {
                        stmt = con.createStatement();
                        rs = stmt.executeQuery(queryString);
                    }
                    int count = 0;
                    int clmnCount = 0;
                    Element nodeDataList = new Element("DataList");
                    if (rs != null)
                    {
                        clmnCount = rs.getMetaData().getColumnCount();
                        while (rs.next())
                        {
                            Element nodeData = new Element("Data");
                            nodeDataList.appendChild(nodeData);
                            count++;

                            for (int f = 1; f <= clmnCount; f++)
                            {
                                if (rs.getString(f) != null && rs.getString(f).trim().length() != 0)
                                {
                                    Element nodeValue = new Element("Value" + f);
                                    nodeValue.appendChild(rs.getString(f).trim());
                                    nodeData.appendChild(nodeValue);
                                }
                            }
                        }
                    }
                    rs.close();
                    stmt.close();

                    if (count <= 0)
                    {
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    if (mainCode == 0)
                    {
                        Element nodeOutXml = new Element("IGGetData_Output");
                        Element nodeExp = new Element("Exception");
                        nodeOutXml.appendChild(nodeExp);

                        Element nodeMainCode = new Element("MainCode");
                        nodeMainCode.appendChild("0");
                        nodeExp.appendChild(nodeMainCode);

                        Attribute atrColCount = new Attribute("Columns", String.valueOf(clmnCount));
                        nodeDataList.addAttribute(atrColCount);
                        nodeOutXml.appendChild(nodeDataList);

                        outputXML = new StringBuffer(nodeOutXml.toXML());
                    }
                    /*	Added by Ashish 08/08/2008		*/
                    if (mainCode == WFSError.WM_NO_MORE_DATA)
                    {
                        outputXML = new StringBuffer(500);
                        outputXML.append(gen.writeError("IGGetData", WFSError.WM_NO_MORE_DATA, 0,
                                WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
                        mainCode = 0;
                    }
                    /*	end Added by Ashish 08/08/2008		*/
                }
                else
                {
                    mainCode = -1;
                    subCode = -1;
                    subject = "Query validation failed.";
                    Element nodeOutXml = new Element("IGGetData_Output");
                    Element nodeExp = new Element("Exception");
                    nodeOutXml.appendChild(nodeExp);
                    Element node = new Element("MainCode");
                    node.appendChild("-1");
                    nodeExp.appendChild(node);

                    node = new Element("TypeOfError");
                    node.appendChild("TEMPORARY");
                    nodeExp.appendChild(node);

                    node = new Element("Subject");
                    node.appendChild(subject);
                    nodeExp.appendChild(node);
                    outputXML = new StringBuffer(nodeOutXml.toXML());
                }
            }
        }
        catch (SQLException e)
        {
            //e.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> getData" + e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0)
            {
                if (e.getSQLState().equalsIgnoreCase("08S01"))
                {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            }
            else
            {
                descr = e.getMessage();
            }
        }
        catch (NumberFormatException e)
        {
            //e.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> getData" + e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (NullPointerException e)
        {
            //e.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> getData" + e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (Exception e)
        {
            //e.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> getData" + e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (Error e)
        {
            //e.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> getData" + e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        finally
        {
            try
            {
                if (rs != null)
                {
                    rs.close();
                    rs = null;
                }
            }
            catch (Exception e)
            {
            }
            try
            {
                if (stmt != null)
                {
                    stmt.close();
                    stmt = null;
                }
            }
            catch (Exception e)
            {
            }
           
           
        }
        if (mainCode != 0)
        {
            LogFilenew("Error::Subject:" + subject + "\r\nError::Desc:" + descr,engine);
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        LogFilenew("Executed.",engine);
        return outputXML.toString();
    }

    public String setData(Connection connection, XMLParser xmlparser, XMLGenerator xmlgenerator) throws JTSException, WFSException
    {
        Statement statement = null;
        int iMainCode = 0;
        int iSubCode = 0;
        String strSubject = null;
        String strDesc = null;
        String strErrType = "TEMPORARY";
        Element nodeOutXml = null;
        String engine = "";
        try
        {
             engine = xmlparser.getValueOf("EngineName");
            LogFilenew("****** SetData ******",engine);

            XMLReader xerces = XMLReaderFactory.createXMLReader(); 
            Builder objBuilder = new Builder(xerces,false);
           // Builder objBuilder = new Builder();
            Document docInput = objBuilder.build(new StringReader(xmlparser.toString()));
            Element rootNode = docInput.getRootElement();

            int iSessionId = Integer.parseInt(rootNode.getFirstChildElement("SessionId").getValue());
            if (WFSUtil.WFCheckSession(connection, iSessionId) == null)
            {
                iMainCode = -1;
                iSubCode = -1;
                strSubject = "Invalid session.";
                strDesc = "Invalid session.";
                nodeOutXml = new Element("IGSetData_Output");
                Element nodeExp = new Element("Exception");
                nodeOutXml.appendChild(nodeExp);
                Element node = new Element("MainCode");
                node.appendChild("-1");
                nodeExp.appendChild(node);

                node = new Element("TypeOfError");
                node.appendChild("TEMPORARY");
                nodeExp.appendChild(node);

                node = new Element("Subject");
                node.appendChild("Invalid session.");
                nodeExp.appendChild(node);
            }
            else
            {
                // transaction started
                if (connection.getAutoCommit())
                {
                    connection.setAutoCommit(false);
                }

                statement = connection.createStatement();

                Elements nodeQueries = rootNode.getChildElements("Query");
                if (nodeQueries != null)
                {
                    for (int i = 0; i < nodeQueries.size(); i++)
                    {
                        Element nodeQuery = nodeQueries.get(i);
                        String strQuery = nodeQuery.getValue();
                        strQuery = WFSUtil.TO_SANITIZE_STRING(strQuery, true);
                        LogFilenew("Input Query:" + strQuery,engine);

                        int iCheckSum = Integer.parseInt(nodeQuery.getAttributeValue("CS"));
                        if (!validateCheckSum(strQuery, iSessionId, iCheckSum,engine))
                        {
                            iMainCode = -1;
                            iSubCode = -1;
                            strSubject = "Query validation failed.";
                            strDesc = "Query validation failed.";
                            nodeOutXml = new Element("IGSetData_Output");
                            Element nodeExp = new Element("Exception");
                            nodeOutXml.appendChild(nodeExp);
                            Element node = new Element("MainCode");
                            node.appendChild("-1");
                            nodeExp.appendChild(node);

                            node = new Element("TypeOfError");
                            node.appendChild("TEMPORARY");
                            nodeExp.appendChild(node);

                            node = new Element("Subject");
                            node.appendChild(strSubject);
                            nodeExp.appendChild(node);
                            return nodeOutXml.toString();
                        }
                        statement.addBatch(strQuery);
                    }
                    int[] iRetVal = statement.executeBatch();
                    statement.close();
                }
                if (iMainCode == 0)
                {
                    nodeOutXml = new Element("IGSetData_Output");
                    Element nodeExp = new Element("Exception");
                    nodeOutXml.appendChild(nodeExp);

                    Element nodeMainCode = new Element("MainCode");
                    nodeMainCode.appendChild("0");
                    nodeExp.appendChild(nodeMainCode);
                }
            }
        }
        catch (SQLException sqlexception)
        {
            //sqlexception.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> setData" + sqlexception);
            iMainCode = 15;
            iSubCode = 801;
            strSubject = WFSErrorMsg.getMessage(iMainCode);
            strErrType = "FATAL";
            if (sqlexception.getErrorCode() == 0)
            {
                if (sqlexception.getSQLState().equalsIgnoreCase("08S01"))
                {
                    strDesc = (new JTSSQLError(sqlexception.getSQLState())).getMessage() + "(SQL State : " + sqlexception.getSQLState() + ")";
                }
            }
            else
            {
                strDesc = sqlexception.getMessage();
            }
        }
        catch (NumberFormatException numberformatexception)
        {
            //numberformatexception.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> setData" + numberformatexception);
            iMainCode = 400;
            iSubCode = 802;
            strSubject = WFSErrorMsg.getMessage(iMainCode);
            strErrType = "TEMPORARY";
            strDesc = numberformatexception.toString();
        }
        catch (NullPointerException nullpointerexception)
        {
			WFSUtil.printErr(engine,"WFCustomBean>> setData" + nullpointerexception);
            //nullpointerexception.printStackTrace();
            iMainCode = 400;
            iSubCode = 803;
            strSubject = WFSErrorMsg.getMessage(iMainCode);
            strErrType = "TEMPORARY";
            strDesc = nullpointerexception.toString();
        }
        //catch (JTSException jtsexception)
        //{
        //    LogFilenew("JTSException");
        //    jtsexception.printStackTrace();
        //    iMainCode = 400;
        //    iSubCode = jtsexception.getErrorCode();
        //    strSubject = WFSErrorMsg.getMessage(iMainCode);
        //    strErrType = "TEMPORARY";
        //    strDesc = jtsexception.getMessage();
        //}
        catch (Exception exception)
        {
            //exception.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> setData" + exception);
            iMainCode = 400;
            iSubCode = 804;
            strSubject = WFSErrorMsg.getMessage(iMainCode);
            strErrType = "TEMPORARY";
            strDesc = exception.toString();
        }
        catch (Error error)
        {
            //error.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> setData" + error);
            iMainCode = 400;
            iSubCode = 804;
            strSubject = WFSErrorMsg.getMessage(iMainCode);
            strErrType = "TEMPORARY";
            strDesc = error.toString();
        }
        finally
        {
            try
            {
                if (iMainCode == 0)
                {
                    if (!connection.getAutoCommit())
                    {
                        connection.commit();
                        connection.setAutoCommit(true);
                    }
                }
                else
                {
                    if (!connection.getAutoCommit())
                    {
                        connection.rollback();
                        connection.setAutoCommit(true);
                    }
                }
                if (statement != null)
                {
                    statement.close();
                    statement = null;
                }
            }
            catch (Exception ignored)
            {
            }
            
        }
        
        if (iMainCode != 0)
        {
            LogFilenew("Error::Subject:" + strSubject + "\r\nError::Desc:" + strDesc,engine);
            throw new WFSException(iMainCode, iSubCode, strErrType, strSubject, strDesc);
        }
        LogFilenew("Executed.",engine);
        return nodeOutXml.toXML();
    }

    public void LogFilenew(String s,String engine)
    {
        FileWriter filewriter = null;
        try
        {            
            File flLog = new File(_strFilepath);
            //2MB = 1024*1024*2 = 2097152
            if (flLog.exists() && flLog.length() >= 2097152)
            {
                //flLog.delete();
                boolean result=flLog.renameTo(new File(_strFilepath+System.currentTimeMillis()));
                if(!result){
                	WFSUtil.printOut(engine,"WFCustomBean>>LogFileNew :: result=false");
                }
                flLog = new File(_strFilepath);
            }
            filewriter = new FileWriter(flLog, true);
            filewriter.write(s);
            filewriter.write("\n");
            filewriter.flush();
        }
        catch (IOException exception)
        {
            //exception.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> LogFilenew" + exception);
        }
        finally
        {
            if (filewriter != null)
            {
                try
                {
                    filewriter.close();
                }
                catch (IOException ex)
                {
                }
            }
        }
    }    

    private boolean validateCheckSum(String pQuery, int pSessionId, int pCheckSum,String engine)
    {
        int iCheckSumCal = calculateCheckSum(pQuery, pSessionId,engine);
        if (pCheckSum == iCheckSumCal)
        {
            return true;
        }
        return false;
    }

    private int calculateCheckSum(String pInput, int pSessionId,String engine)
    {
        try
        {
            MessageDigest md = MessageDigest.getInstance(WFSConstant.WF_MD5);
            md.update(pInput.getBytes(WFSConstant.WF_UTF16));
            md.update(String.valueOf(pSessionId).getBytes(WFSConstant.WF_UTF16));
            byte[] digest = md.digest();
            int decValue = 0;
            for (int i = 0; i < digest.length; i++)
            {
                if (digest[i] >= 0)
                {
                    decValue += digest[i];
                }
                else
                {
                    decValue += 256 + digest[i];
                }
            }
            return decValue;
        }
        catch (Exception ex)
        {
            //ex.printStackTrace();
			WFSUtil.printErr(engine,"WFCustomBean>> calculateCheckSum" + ex);
        }	
        finally
        {
        }
        return 0;
    }

}//end of WFCustomBeanClass