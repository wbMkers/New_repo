//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group							: Application �Products
//Product / Project				: Omniflow 6.2
//Module						: Omniflow Server
//File Name						: WFSCustomClientProp.java
//Author						: Ruhi Hira
//Date written (DD/MM/YYYY)		: 17/01/2008
//Description					: Wrapper over WFSCustomClientData.xml (Inherited from WFSClientProp)
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By	 Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//
//
//
//----------------------------------------------------------------------------------------------------
// 30/05/2013           Kahkeshan           Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.

package com.newgen.omni.jts.client;

import java.io.*;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.util.WFSUtil;

public final class WFSCustomClientProp {

    private static WFSCustomClientProp customClientProp = new WFSCustomClientProp();
    private String sjndiServerPort = null;
    private String sjndiServerName = null;
    private String sApplicationServerName = null;

    public static WFSCustomClientProp getReference() {
        return customClientProp;
    }

    {
        StringBuffer sbXml = new StringBuffer();
        try {
            BufferedReader br = new BufferedReader(new FileReader("ngdbini/WFSCustomClientData.xml"));
            String str;
            int ch = 0;
            do {
                str = br.readLine();
                if (str != null)
                    sbXml.append(str);

            } while (str != null);
            br.close();
            br = null;
        } catch (FileNotFoundException e) {
			 WFSUtil.printErr("","WFSCustomClientProp>> FileNotFoundException" + e);
        } catch (IOException ioe) {
             WFSUtil.printErr("","WFSCustomClientProp>> IOException" + ioe);
        }
        XMLParser toParse = new XMLParser(sbXml.toString());
        this.sjndiServerName = toParse.getValueOf("jndiServerName");
        this.sjndiServerPort = toParse.getValueOf("jndiServerPort");
        this.sApplicationServerName = toParse.getValueOf("ApplicationServerName");
        sbXml = null;
        toParse = null;
    }

    public String getJndiServerName() {
        return this.sjndiServerName;
    }

    public String getJndiServerPort() {
        return this.sjndiServerPort;
    }

    public String getApplicationServerName() {
        return this.sApplicationServerName;
    }

} // end of class WFSCustomClientProp