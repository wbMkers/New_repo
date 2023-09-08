//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group							: Application �Products 
//Product / Project				: WorkFlow
//Module						: EJB
//File Name						: WFSClientProp.java
//Author						: Ashish Mangla
//Date written (DD/MM/YYYY)		: 17/12/2004
//Description					: Main Bean for WFClientServiceHandlerBean
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
// 15/12/2006     Shilpi        Bug#369
// 07/04/2009	Prateek Tandon  WFS_6.2_078 Removal of password tag from wrapper logs and wrapper logs made configurable.Change in architecture of wrapper.
// 10/07/2012  	Tanisha Ghai   	Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.client;

import java.io.*;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.constt.WFSConstant;
public final class WFSClientProp
{
	private static WFSClientProp clientProp = new WFSClientProp();
	private String sjndiServerPort;
	private String sjndiServerName;
	private String sApplicationServerName = null;
    private String sClusterName=null;
	
	//----------------------------------------------------------------------------------------------------
	//Function Name 		:	getReference
	//Date Written (DD/MM/YYYY): 29/03/2002
	//Author				: Atam Govil
	//Input Parameters		: None
	//Return Values			: Object of WFSClientProp.
	//Description			: returns Object of WFSClientProp.
	//----------------------------------------------------------------------------------------------------
	public static WFSClientProp getReference()
	{
		return clientProp;
	}

    //----------------------------------------------------------------------------------------------------
	//Function Name 		:	intialization block 
	//Date Written (DD/MM/YYYY): 29/03/2002
	//Author				: Atam Govil
	//Input Parameters		: None
	//Return Values			: None
	//Description			: Read xml file and store all info.
	//----------------------------------------------------------------------------------------------------
	{
		StringBuffer sbXml = new StringBuffer();
		try{
			BufferedReader br = new BufferedReader(new FileReader(WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + "WFSClientData.xml"));
			String str;
			int ch=0;
			do
			{
				  str = br.readLine();
				  if (str != null)
					sbXml.append(str);
			
			}while (str!=null);
			br.close();
			br = null;
		}
		catch(FileNotFoundException e){
			WFSUtil.printErr("","File (WFSConfig/WFSClientData.xml) Not Found.", e);
		}
		catch(IOException ioe){
			WFSUtil.printErr("","", ioe);
		}
		XMLParser toParse = new XMLParser(sbXml.toString());
		this.sjndiServerName = toParse.getValueOf("jndiServerName");
		this.sjndiServerPort = toParse.getValueOf("jndiServerPort");
		this.sApplicationServerName = toParse.getValueOf("ApplicationServerName");
        this.sClusterName=toParse.getValueOf("ClusterName");
		sbXml = null;
		toParse = null;
	}

    //----------------------------------------------------------------------------------------------------
	//Function Name 		:	getJndiServerName
	//Date Written (DD/MM/YYYY): 29/03/2002
	//Author				: Atam Govil
	//Input Parameters		: None
	//Return Values			: Jndi Server name 
	//Description			: returns Jndi Server name as String.
	//----------------------------------------------------------------------------------------------------
	public String getJndiServerName(){
		return this.sjndiServerName;
	}

	//----------------------------------------------------------------------------------------------------
	//Function Name 		:	getJndiServerPort
	//Date Written (DD/MM/YYYY): 29/03/2002
	//Author				: Atam Govil
	//Input Parameters		: None
	//Return Values			: Jndi Server port
	//Description			: returns Jndi Server port as String.
	//----------------------------------------------------------------------------------------------------
	public String getJndiServerPort(){
		return this.sjndiServerPort;
	}

	public String getApplicationServerName() {
        return this.sApplicationServerName;
    }
        
    public String getClusterName() {
       return this.sClusterName;
    }

	// Added By Dinesh Parikh
	// Whenever serverproperty for Log is changed then flag should be changed at run time also at write in file
	/*public void changeClientProp(String xmlLogFlag, String tranLogFlag){
		//Write into file
		StringBuffer sbXml = new StringBuffer();
		BufferedReader br = null;
		BufferedWriter bw = null;
		try{
			br = new BufferedReader(new FileReader("WFSConfig/WFSClientData.xml"));
			String str;
			int ch=0;
			do
			{
				  str = br.readLine();
				  if (str != null)
					sbXml.append(str);
			
			}while (str!=null);
			br.close();
			XMLParser toParse = new XMLParser(sbXml.toString());
			sbXml = new StringBuffer();
			XMLGenerator generator = new XMLGenerator();
			sbXml.append("<?xml version=\"1.0\"?><ClientInfo>");
			sbXml.append(generator.writeValueOf("jndiServerName", toParse.getValueOf("jndiServerName")));
			sbXml.append(generator.writeValueOf("jndiServerPort", toParse.getValueOf("jndiServerPort")));
			sbXml.append(generator.writeValueOf("ProviderUrl", toParse.getValueOf("ProviderUrl")));
			sbXml.append(generator.writeValueOf("JndiContextFactory", toParse.getValueOf("JndiContextFactory")));
			sbXml.append("<Debug>");
			sbXml.append(generator.writeValueOf("XMLLog", xmlLogFlag));
			sbXml.append(generator.writeValueOf("TransactionLog", tranLogFlag));
			sbXml.append("</Debug></ClientInfo>");
			bw = new BufferedWriter( new FileWriter("WFSConfig/WFSClientData.xml" , false));
			bw.write(sbXml.toString());
			bw.flush();
			sbXml = null;
			toParse = null;
			generator = null;
		}
		catch(FileNotFoundException e){
			e.printStackTrace();
			WFSUtil.printErr("File (WFSConfig/WFSClientData.xml) Not Found.");
		}
		catch(IOException ioe){
			ioe.printStackTrace();
		}
		finally{
			try{
				if(bw != null) bw.close();
				if(br != null) br.close();
			}catch(Exception e){}
		}
	}*/

}// end of class WFSClientProp
