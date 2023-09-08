
//-----------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group                 : Genesis
//Product / Project     : OmniDocs
//Module                : Archive
//File Name             : ArchiveService.java
//Author                : Pranay Tiwari
//Date written          : 31/01/2014
//-----------------------------------------------------------------------------------
//			CHANGE HISTORY
//-----------------------------------------------------------------------------------
// Date			 Change By              Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//-----------------------------------------------------------------------------------
//05/06/2014	Mohnish Chopra			Changes added for Oracle in Archival
//-----------------------------------------------------------------------------------
package com.newgen.omni.archive;

import java.io.*;
import java.util.*;
import java.sql.*;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author pranay.tiwari
 */
public class ArchiveService {

    ArchiveService (){}

    public int startArchive() throws Exception
    {
        File InfoFile;
        Properties prop = new Properties();
        String srcCab,trgCab,dbType,dbLink,dbDriver,dbUrl,dbUser,dbpwd,useDBLink;
        String localDbLinkVar =null;
        String strVolBlockPath = null,query = null,lsrcLinkName = null,lTargetCab = null;
        Connection con = null;
        Statement stmt = null;
        PreparedStatement pstmt = null,pstmt1 = null;
        ResultSet rs = null,rs1 = null;
        CallableStatement cstmt = null;
        int intcolumnValue = 0;
        String srcLabelpath,targLabelpath,sourceMachineIp;
        

		System.out.println("Archive Service Execution IS Starting");

        try{
            InfoFile    = new File("input" + File.separator + "ArchiveInfo.properties");
            prop.load(new FileInputStream(InfoFile));
            srcCab      = prop.getProperty("SourceCabinet");
            trgCab      = prop.getProperty("TargetCabinet");
            dbType      = prop.getProperty("DBType");
            useDBLink   = prop.getProperty("USEDBLink");
            if(useDBLink.equalsIgnoreCase("N")){
            	dbLink = null;
            }
            else{
            dbLink      = prop.getProperty("DBLink");
            }
            dbDriver    = prop.getProperty("DBDriver");
            dbUrl       = prop.getProperty("DBurl");
            dbUser      = prop.getProperty("DBUserName");
            dbpwd       = prop.getProperty("DBPassword");
            sourceMachineIp      = prop.getProperty("sourceMachineIp");

        }
        catch(IOException e)
        {
            System.err.println("ArchiveInfo.properties not found.");
            e.printStackTrace();
            return 1;
        }

        //start DB operations
        Class.forName(dbDriver);
        if (dbType.equalsIgnoreCase("mssql"))
        {
                Properties connectionInfo = new Properties();
                connectionInfo.put( "user" , dbUser);
                connectionInfo.put( "password" , dbpwd);
                connectionInfo.put( "DatabaseName" , trgCab);
                con = DriverManager.getConnection(dbUrl, connectionInfo);
        }
        else
            con = DriverManager.getConnection(dbUrl,dbUser,dbpwd);
        
        if(dbType.equalsIgnoreCase("mssql"))
        {	

            if(useDBLink.equalsIgnoreCase("Y"))
                lsrcLinkName = "[" + sourceMachineIp + "]." + srcCab + ".dbo.";
            else
                lsrcLinkName = srcCab + "..";

            lTargetCab = trgCab + "..";

            query = "INSERT INTO "+ lTargetCab + "MOVEPNFILELIST" +
                    " select VOLUMEID,VOLBLOCKID,SITEID,'PN'+ dbo.BaseConv(VOLUMEID)+dbo.BaseConv(VOLBLOCKID)+'.'+dbo.BaseConv(SITEID)" +
                    " FROM ( SELECT VOLUMEID,VOLBLOCKID,SITEID FROM "+ lsrcLinkName +"ISDOC GROUP BY VOLUMEID,VOLBLOCKID,SITEID"+
                    " except SELECT VOLUMEID,VOLBLOCKID,SITEID FROM "+ lsrcLinkName +"ISDOC WHERE ArchiveFlag='N' GROUP BY VOLUMEID,VOLBLOCKID,SITEID) as A";

        }
        else if(dbType.equalsIgnoreCase("oracle"))
        {
			if(useDBLink.equalsIgnoreCase("Y")){
							localDbLinkVar = "@"+dbLink;
						}
			else {
				localDbLinkVar = " ";
			}
            lTargetCab = trgCab + ".";

			query = "INSERT INTO "+ lTargetCab + "MOVEPNFILELIST" +
								   " SELECT VOLUMEID,VOLBLOCKID,SITEID," +
			"CONCAT('PN',CONCAT(lpad(BaseConv(VOLUMEID,10,36),3,0), CONCAT(lpad(BaseConv(VOLBLOCKID,10,36),3,0), CONCAT ('.',lpad(BaseConv(SITEID,10,36),3,0)))))" +
								   " FROM (SELECT VOLUMEID,VOLBLOCKID,SITEID" +
								   " FROM " + srcCab + ".ISDOC" + localDbLinkVar + " GROUP BY VOLUMEID,VOLBLOCKID,SITEID" +
								   " MINUS SELECT VOLUMEID,VOLBLOCKID,SITEID FROM " + srcCab + ".ISDOC" + localDbLinkVar +
								   " WHERE ArchiveFlag='N' GROUP BY VOLUMEID,VOLBLOCKID,SITEID)";
        }
        else
        {
            System.err.println("DataBase not supported, please check ArchiveInfo.properties file.");
            return 1;
        }

        try
        {
            stmt = con.createStatement();
            stmt.execute(query);
        }
        finally
        {
            if (stmt != null){
                stmt.close();
                stmt = null;
            }
        }

        query = "SELECT VOLUMEID,VOLBLOCKID,SITEID,PNFile FROM "+ lTargetCab + "MOVEPNFILELIST";
        try
        {

            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next())

            {	
                int volId = rs.getInt(1);
                int vbId = rs.getInt(2);
                int siteId = rs.getInt(3);
                String pnFile = rs.getString(4);

                //get current volblockid
                if(dbType.equalsIgnoreCase("mssql"))
                    pstmt1 = con.prepareStatement("SELECT currvolblock FROM " + lsrcLinkName + "ISVoldef WHERE SiteId = ? AND VolumeId = ?");
                else
                    pstmt1 = con.prepareStatement("SELECT currvolblock FROM " + srcCab + ".ISVoldef" + localDbLinkVar+ " WHERE SiteId = ? AND VolumeId = ?");
                pstmt1.setInt(1, siteId);
                pstmt1.setInt(2, volId);
                rs1 = pstmt1.executeQuery();
                if (rs1.next()){
                    intcolumnValue = rs1.getInt(1);
                }


                
                if (intcolumnValue == vbId)

					continue;
                rs1.close();
                pstmt1.close();

                //get VolBlockPath or Label
                if(dbType.equalsIgnoreCase("mssql"))
                    pstmt1 = con.prepareStatement("SELECT VolBlockPath FROM " + lsrcLinkName + "ISVolBlock WHERE SiteId = ? AND VolumeId = ? AND VolBlockId = ?");
                else
                    pstmt1 = con.prepareStatement("SELECT VolBlockPath FROM " + srcCab + ".ISVolBlock" + localDbLinkVar + " WHERE SiteId = ? AND VolumeId = ? AND VolBlockId = ?");
                pstmt1.setInt(1, siteId);
                pstmt1.setInt(2, volId);
                pstmt1.setInt(3, vbId);
                rs1 = pstmt1.executeQuery();
                if (rs1.next()){
                    strVolBlockPath = rs1.getString(1);
                }
                rs1.close();
                pstmt1.close();

                try
                {
                    InfoFile = new File("input" + File.separator + "SrcLableInfo.properties");
                    prop.load(new FileInputStream(InfoFile));
                    srcLabelpath      = prop.getProperty(strVolBlockPath.substring(4).toUpperCase().trim());

                    InfoFile = new File("input" + File.separator + "DestLableInfo.properties");
                    prop.load(new FileInputStream(InfoFile));
                    targLabelpath      = prop.getProperty(strVolBlockPath.substring(4).toUpperCase().trim());
                }
                catch(IOException e)
                {
                    System.err.println("SrcLableInfo.properties or DestLableInfo.properties not found.");
                    e.printStackTrace();
                    return 1;
                }

                if(srcLabelpath == null || targLabelpath == null)
                {
                   System.err.println("Label not found in SrcLableInfo.properties or DestLableInfo.properties, Please contact Administrator.");
                   return 1;
                }

                File srcFileObj = new File(srcLabelpath+pnFile);
                File destFileObj = new File(targLabelpath+pnFile);

                if(!srcFileObj.exists())
                {
                    System.err.println("Error in opening the file. File ("+srcLabelpath+") does not exist.");
                    return 1;
                }

                String parentDir = destFileObj.getParent();
                File parentDirObj = new File(parentDir);
                if(!parentDirObj.exists())
                {
                    System.err.println("Error in opening the directory. Directory ("+parentDir+") does not exist.");
                    return 1;
                }

                try
                {
                    FileUtils.copyFile(srcFileObj, destFileObj);

                }
                catch(NullPointerException ex)
                {
                    System.err.println("Some exception occurred, either source or destination is null");
                    ex.printStackTrace();
                    return 1;
                }
                catch(IOException ex)
                {
                    System.err.println("Some IOException occurred");
                    ex.printStackTrace();
                    return 1;
                }
                catch(Exception ex)
                {
                    System.err.println("Some Exception occurred");
                    ex.printStackTrace();
                    return 1;
                }
                catch(Error ex)
                {
                    System.err.println("Some Error occurred");
                    ex.printStackTrace();
                    return 1;
                }
				System.out.println("bwfore Executing MoveIsDOc");
                //call procedure MoveISDoc
                if(dbType.equalsIgnoreCase("mssql"))
                {	
					System.out.println("Executing MoveIsDOc");
                    cstmt = con.prepareCall("exec MoveISDoc ?,?,?,?,?,?,?");
                }
                else if(dbType.equalsIgnoreCase("oracle"))
                {
                    cstmt = con.prepareCall("{call MoveISDoc(?,?,?,?,?,?,?)}");
                }
                cstmt.setString(1,srcCab);
                cstmt.setString(2,trgCab);
                if(dbType.equalsIgnoreCase("mssql")){
                        if(useDBLink.equalsIgnoreCase("Y"))
                            cstmt.setString(3,sourceMachineIp);
                        else
                            cstmt.setString(3,null);
                       
                }
                
                else
                    cstmt.setString(3,dbLink);
                cstmt.setInt(4,volId);
                cstmt.setInt(5,vbId);
                cstmt.setInt(6,siteId);
                cstmt.registerOutParameter(7, Types.INTEGER);
                cstmt.execute();

                int intColumnValue = cstmt.getInt(7);
                if (intColumnValue != 0){
                    System.err.println("Error in procedure MoveISDoc, Status: "+intColumnValue);
                    return 1;
                }
                System.out.println("Success in procedure MoveISDoc, Status: "+intColumnValue);


                //delete PN file from source
                FileUtils.deleteQuietly(srcFileObj);

                //delete entry from MOVEPNFILELIST
                pstmt1 = con.prepareStatement("DELETE FROM "+ lTargetCab + "MOVEPNFILELIST WHERE SiteId = ? AND VolumeId = ? AND VolBlockId = ?");
                pstmt1.setInt(1, siteId);
                pstmt1.setInt(2, volId);
                pstmt1.setInt(3, vbId);
                pstmt1.execute();
                pstmt1.close();

            }
        }
        catch(SQLException e) {
            System.err.println("Some SQLException occurred");
            e.printStackTrace();
            return 1;
        }
        catch(Exception e) {
            System.err.println("Some Exception occurred");
            e.printStackTrace();
            return 1;
        }
        catch(Error e) {
            System.err.println("Some Error occurred");
            e.printStackTrace();
            return 1;
        }
        finally
        {
            if (stmt != null){
                stmt.close();
                stmt = null;
            }
            if (rs1 != null){
                rs1.close();
                rs1 = null;
            }
			if (rs != null){
                rs.close();
                rs = null;
            }
            if (pstmt1 != null){
                pstmt1.close();
                pstmt1 = null;
            }
            if(cstmt != null){
                cstmt.close();
                cstmt = null;
            }
        }

        return 0;
    }
}
