
//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application �Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WFDestinationMapping.java
//	Author					: Virochan
//	Date written(DD/MM/YYYY): 19/09/2005
//	Description				: Reads file Mapping.xml into a HashMap.
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// 30/12/2005				Virochan        WFS_6.1.2_005, BufferedReader closed and null
// 30/12/2005				Virochan		WFS_6.1.2_004, file name is read from WFSConstant
// 18/10/2007				Varun Bhansaly	WFMapping.xml to be placed inside folder WFSConfig whose location 
//											will be configurable
// 19/10/2007				Varun Bhansaly	SrNo-1, Use WFSUtil.printXXX instead of System.out.println()
//											System.err.println() & printStackTrace() for logging.
// 15/01/2008               Varun Bhansaly  Mapping File to be read using WFSUtil.readFile()
//----------------------------------------------------------------------------------------------------


package com.newgen.omni.jts.mdb;

import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

import java.util.*;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;


public class WFDestinationMapping {
	private static HashMap map = null;
	private static WFDestinationMapping destinationMapping = null;
	private static WFConfigLocator configLocator;
    private static String configPath;
	private WFDestinationMapping() {
        try{
            readMappingFromFile();
        }catch(Exception ex){
            WFSUtil.printErr("","[WFDestinationMapping] ", ex);
	    }
    }

	public static WFDestinationMapping getReference(){
		if(destinationMapping == null){
			//WFSUtil.printOut(""," DestinationMapping is null");
			configLocator = WFConfigLocator.getInstance();
            configPath = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.FILE_WFMAPPING;
            destinationMapping = new WFDestinationMapping();
		}
		return destinationMapping;
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	isMapNull
//	Date Written (DD/MM/YYYY)	:	19/09/2005
//	Author						:	Virochan
//	Input Parameters			:	none
//	Output Parameters			:   none
//	Return Values				:	boolean
//	Description					:   Return true if map is null otherwise false
//----------------------------------------------------------------------------------------------------

	public boolean isMapNull(){
		if(map==null)
			return true;
		else
			return false;
	}


//----------------------------------------------------------------------------------------------------
//	Function Name 				:	readMappingFromFile
//	Date Written (DD/MM/YYYY)	:	19/09/2005
//	Author						:	Virochan
//	Input Parameters			:	none
//	Output Parameters			:   none
//	Return Values				:	void
//	Description					:   Reading Mapping.xml
//----------------------------------------------------------------------------------------------------

	public void readMappingFromFile() throws java.io.IOException{
		//WFS_6.1.2_004, file name is read from WFSConstant
        if(!isMapNull()){
            map = null;
        }
        map = new HashMap();
        String mappingXML = WFSUtil.readFile(configPath);
		XMLParser parser = new XMLParser(mappingXML);
		int numberOfFields = parser.getNoOfFields("Mapping");
		//WFSUtil.printOut("","[WFDestinationMapping] NoOffields ::" + numberOfFields);
		String mapping = parser.getFirstValueOf("Mapping");
		populateMappingIntoMap(mapping);
		for(int i=1;i<numberOfFields;i++){
			mapping = parser.getNextValueOf("Mapping");
			populateMappingIntoMap(mapping);
		}
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	populateMappingIntoMap
//	Date Written (DD/MM/YYYY)	:	19/09/2005
//	Author						:	Virochan
//	Input Parameters			:	String
//	Output Parameters			:   none
//	Return Values				:	void
//	Description					:   Inserting values (Cabinet Names) into the HashMap corresponding to some destination name
//----------------------------------------------------------------------------------------------------

	private void populateMappingIntoMap(String mapping)
	{
		XMLParser parser = new XMLParser(mapping);

		String DestinationName=parser.getValueOf("DestinationName");
		String EngineName = parser.getValueOf("EngineName");
                EngineName = EngineName.toLowerCase();
               // WFSUtil.printOut(EngineName,"[WFDestinationMapping] DestinatioName :: "+ DestinationName);
		
		//WFSUtil.printOut(EngineName,"[WFDestinationMapping] EngineName :: "+EngineName);
		ArrayList cabinetList = null;
		cabinetList = (ArrayList)map.get(DestinationName);
		boolean bool = true;

		if(cabinetList==null)
		{
			
			ArrayList newList = new ArrayList();
			newList.add(EngineName);
			map.put(DestinationName, newList);
		}
	    else{
			for(int i=0;i<cabinetList.size();i++)
			{
			  if(cabinetList.get(i).equals(EngineName)) //Engine name is changed to lowercase.
			  {
				  bool = false;
				  break;
			  }
			  else{
				  bool = true;
			  }
			}

			if(bool)
			  cabinetList.add(EngineName);
		}
	}


//------------------------------------------------------------------------------------------------------------
//	Function Name 				:	getCabinetList
//	Date Written (DD/MM/YYYY)	:	19/09/2005
//	Author						:	Virochan
//	Input Parameters			:	String
//	Output Parameters			:   none
//	Return Values				:	ArrayList
//	Description					:   Getting cabinet names into an ArrayList correponding to the destination.
//-------------------------------------------------------------------------------------------------------------

	public ArrayList getCabinetList(String DestinationName){
		ArrayList cabinetList = (ArrayList)map.get(DestinationName);
        if(cabinetList == null){
            WFSUtil.printOut("","[WFDestinationMapping] No cabinet is mapped to the destination :: " + DestinationName);
            WFSUtil.printOut("","[WFDestinationMapping] Check WFMapping.xml");
        }
		return cabinetList;
	}

   /**
     * *************************************************************
     * Function Name    :   wfGetDestinationMappingMap
     * Author			:   Varun Bhansaly
     * Date Written     :   15/01/2008
     * Input Parameters :   NONE
     * Output Parameters:   NONE
     * Return Value     :   HashMap
     * Description      :   Returns HashMap containing relation b/w 
     *                      JMSDestination and Cabinet 
     * *************************************************************
    */
    public HashMap wfGetDestinationMappingMap(){
        return map;
    }

    /**
     * *************************************************************
     * Function Name    :   wfGetConfigFilePath
     * Author			:   Varun Bhansaly
     * Date Written     :   15/01/2008
     * Input Parameters :   NONE
     * Output Parameters:   NONE
     * Return Value     :   String
     * Description      :   returns location of WFMapping.xml
     * *************************************************************
    */
    public String wfGetConfigFilePath(){
        return configPath;
    }
}