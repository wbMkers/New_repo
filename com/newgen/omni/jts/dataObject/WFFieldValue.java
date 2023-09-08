/* ------------------------------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 7.2
             Module				: WFVariableCache for new fetch/set attributes  
             File Name			: WFFieldInfo.java
             Author				: Shweta Tyagi
             Date written		: 
             Description		: Object to hold information for every variable (complex/primitive) 
 ----------------------------------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)
//06/06/2008	Shweta Tyagi	SrNo-1 ShortDate and Time support in BPEL Compliant OmniFlow
//26/06/2008	Shweta Tyagi	SrNo-2 No tag return if no row in table for complex structure
//11/07/2008	Shweta Tyagi	Bugzilla Bug 5528
//14/08/2008    Varun Bhansaly  Bugzilla Id 5976,
//26/08/2008    Varun Bhansaly  Sr.No.3, New property rightsInfo added to WFFieldValue object
//                              method serializeAsXML would return new attributes VariableId, VarFieldId, Type
// 02/01/2009   Shweta Tyagi    Bugzilla Bug 7357
05/07/2012      Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
21/03/2013      Kahkeshan       Bug 35729 - Defaults values are not showing in Workitem
02/04/2013      Kahkeshan       Bug 35729 - Defaults values are not showing in Workitem ,Changes made corresponding to Oracle Database
28/01/2014	    Kahkeshan		Exception thrown in serializeAsXml .
28/01/2014  	Kahkeshan		removing unnecessary debugs.
05/05/2017     Kumar Kimil         Bug 64957 - Data is getting changed while moving to export table
17/05/2017      Mohnish Chopra  Changes for Nested Complex array requirement-Updation & Batching
24/08/2017		Mohnish Chopra	Changes for Bug 71104 - InsertionOrderId tag in the ComplexArrayTag is not getting returned whenUserDefVarFlag is passed as X in input of WMFetchWorkItemAttribute API call
13/07/2018		Ambuj Tripathi	Bank Audi Optimization Requirement/Issue - Thread is locked on system.getproperty() method.
//26/12/2018    Ravi Ranjan Kumar  Bug 82091 - Support of view , fetching data from view for complex variable if view is defined otherwise data will fetch from table
//02/03/2022    Ashutosh Pandey    Bug 105376 - Support for sorting on complex array primitive member
 ----------------------------------------------------------------------------------------------------*/

package com.newgen.omni.jts.dataObject;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.util.*;
import java.util.*;
import java.text.*;
import org.w3c.dom.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.constt.*;

public class WFFieldValue {

    private int variableId = 0;
    private int varFieldId = 0;
    private String name = null ;
    private ArrayList values;			//when single value elements arraylist will have just one element
	private int wfType = 0;
    private char scope = '\0';
	private int length = 0 ;
    private int precison = 0;
	private ArrayList listOfMaps;		//list of child maps corresponding to WFFieldInfo
	private String parentInfo ;
    private String rightsInfo;
    private ArrayList insertionOrderIdValues;
    private String isView="N";
    private static final String lineSeperator = System.getProperty("line.separator");
    
    public String toString() {
        StringBuffer buffer = new StringBuffer(100);
        buffer.append(" *** WFFieldValue *** ");
        buffer.append(lineSeperator + "Name - " + name);
        buffer.append(lineSeperator + "Type - " + wfType);
        buffer.append(lineSeperator + "variableId - " + variableId);
        buffer.append(lineSeperator + "varFieldId - " + varFieldId);
        buffer.append(lineSeperator + "Scope - " + scope);
        buffer.append(lineSeperator + "values - " + values);
        buffer.append(lineSeperator + "length - " + length);
        buffer.append(lineSeperator + "precision - " + precison);
        buffer.append(lineSeperator + "listOfMaps - " + listOfMaps);
        buffer.append(lineSeperator + "parentInfo - " + parentInfo);
        buffer.append(lineSeperator + "InsertionOrderIdValues - " + getInsertionOrderIdValues());

        return buffer.toString();
    }
   /**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used for queue variables)
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId, int varFieldId, String name,String value, int wfType, char scope, int length
								  int precison 
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
   */
	public WFFieldValue(int variableId, String name,String value, int wfType, int length, int precison ) {
        this(variableId, 0, name, value, wfType, '\0', length, precison, null);
    }
    
/**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used by complex/arrays)
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId, int varFieldId, String name,String value, int wfType, char scope, int length
								  int precison 
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
   */
	public WFFieldValue (int variableId, int varFieldId, String name,ArrayList values, int wfType, char scope, int length, int precison, String parentInfo) {
		this.variableId = variableId ;
		this.varFieldId = varFieldId ;
		this.name = name ;
		this.values = values ;
		this.wfType = wfType ;
		this.scope =  scope ;
		this.length = length ;
		this.precison = precison ;
		this.parentInfo = parentInfo ;
	
    }
    public WFFieldValue (int variableId, int varFieldId, String name,ArrayList values, int wfType, char scope, int length, int precison, String parentInfo ,ArrayList insertionOrderIdValues) {
		this.variableId = variableId ;
		this.varFieldId = varFieldId ;
		this.name = name ;
		this.values = values ;
		this.wfType = wfType ;
		this.scope =  scope ;
		this.length = length ;
		this.precison = precison ;
		this.parentInfo = parentInfo ;
	    setInsertionOrderIdValues(insertionOrderIdValues);

    }
    /**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used by complex/arrays)
     *      Date Written        : 7/12/2018
     *      Author              : Ravi Ranjan Kumar
     *      Input Parameters    : int variableId, int varFieldId, String name,String value, int wfType, char scope, int length, int precison, String parentInfo ,ArrayList insertionOrderIdValues,String isView
								  int precison 
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
   */
    public WFFieldValue (int variableId, int varFieldId, String name,ArrayList values, int wfType, char scope, int length, int precison, String parentInfo ,ArrayList insertionOrderIdValues,String isView) {
		this.variableId = variableId ;
		this.varFieldId = varFieldId ;
		this.name = name ;
		this.values = values ;
		this.wfType = wfType ;
		this.scope =  scope ;
		this.length = length ;
		this.precison = precison ;
		this.parentInfo = parentInfo ;
		this.isView=isView;
	    setInsertionOrderIdValues(insertionOrderIdValues);

    }
    
	/**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used by complex/arrays)
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId, int varFieldId, String name,String value, int wfType, char scope, int length
								  int precison 
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
   */
    public WFFieldValue (int variableId, int varFieldId, String name,String value, int wfType, char scope, int length, int precison, String parentInfo ) {
        this(variableId, varFieldId, name, new ArrayList(1), wfType, scope, length, precison, parentInfo);
        this.values.add(value) ;
    }

    /**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used by complex)
     *      Date Written        : 12/07/2018
     *      Author              : Ravi Ranjan Kumar
     *      Input Parameters    : int variableId, int varFieldId, String name,String value, int wfType, char scope, int length
								  int precison, String parentInfo ,String isMappedView
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
   */
    public WFFieldValue (int variableId, int varFieldId, String name,String value, int wfType, char scope, int length, int precison, String parentInfo ,String isView) {
        this(variableId, varFieldId, name,value,wfType,scope,length,precison,parentInfo);
        this.setIsView(isView) ;
    }
/**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used for queue/ext variables)
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId , String name , int wfType,int extObjId char scope, int length
								  int precison
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
*/
    public WFFieldValue(int variableId, int varFieldId, String name,String value, int wfType,char scope, int length, int precison ) {
        this(variableId, varFieldId, name, value, wfType, scope, length, precison, null);
	}
/**
     * *******************************************************************************
     *      Function Name       : Constructor(will be used for queue/ext variables)
     *      Date Written        : 17/04/2007
     *      Author              : Shweta Tyagi
     *      Input Parameters    : int variableId , String name , int wfType,int extObjId char scope, int length
								  int precison
     *      Output Parameters   : NONE
     *      Return Values       : WFFieldInfo object
     *      Description         : constructor for this class, WFFieldInfo.
     * *******************************************************************************
*/
    public WFFieldValue(int variableId, String name,String value, int wfType,char scope, int length, int precison ) {
        this(variableId, 0, name, value, wfType, scope, length, precison, null);
	}
    
	 public int getVariableId(){
			return variableId;
		}
	 public int getVarFieldId(){
			return varFieldId;
		}
	 public String getName(){
			return name;
		}
	 public ArrayList getValues(){
			return values;
	    }
	 public int getWfType(){
			return wfType;
		}
	 public char getScope(){
			return scope;
		}
	 public int getLength(){
			return length;
		}
	 public int getPrecison(){
			return precison;
		}
	 public ArrayList getListOfMaps(){
			return listOfMaps ;
		}
	  public String getParentInfo(){
			return parentInfo ;
		}
      
    public String getRightsInfo() {
        return rightsInfo;
    }
	 public void setVariableId(int variableId){
        this.variableId = variableId;
       }
	 public void setVarFieldId(int varFieldId ){
        this.varFieldId = varFieldId;
       }
	 public void setName(String name){
        this.name = name;
       }
	 public void setValues(ArrayList values){
        this.values = values;
       }
	 public void setWfType(int wfType){
        this.wfType = wfType;
       }
	 public void setScope(char scope){
        this.scope = scope;
       }
	 public void setLength(int length){
        this.length = length;
       }
	  public void setPrecison(int precison){
			this.precison = precison;
		}
	 public void setListOfMaps(ArrayList listOfMaps){
        this.listOfMaps = listOfMaps;
       }
	 public void setParentInfo(String parentInfo){
        this.parentInfo = parentInfo;
       }
    
    public void setRightsInfo(String rightsInfo) {
        this.rightsInfo = rightsInfo;
    }
    
     public boolean isComplex(){
        return (wfType == WFSConstant.WF_COMPLEX);
    }
	
    /**
     * *******************************************************************
     * Function Name    :   serializeAsXML
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   Document -> fieldValueAsXML (This is the document object)
     *                      Node -> parent (This is the node which will act as a parent)
     * Output Parameters:   NONE
     * Return Value     :   String
     * Description      :   It converts this object into XML.
     * *******************************************************************
     */ 
     public void serializeAsXML(Document fieldValueAsXML, Node parent, String engineName) throws Exception{
         serializeAsXML(fieldValueAsXML, parent, engineName, true);
     }
     
 	public void serializeAsXML(Document fieldValueAsXML, Node parent, String engineName, boolean fetchAttributeProperty) throws Exception{
        //WFSUtil.printOut(engineName,toString());
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", Locale.US);//SrNo-1 
		ParsePosition pos = new ParsePosition(0);
        String value = "";
		//try {
			if (!isComplex()) {
				 int i = 0;
                /** Now, this could be either a primitive or a primitive array. - Varun Bhansaly */
				ArrayList vals = this.getValues();
			    ArrayList insertionOrderIdValues = getInsertionOrderIdValues();
			    String insertionOrderIdValue = "";
			    String maxInsertionOrderIdValue = "";
			    String minInsertionOrderIdValue = "";
				if (vals.size() == 0) {
                    populateNode(parent, value, fetchAttributeProperty);
				} else {
					ListIterator itr1 = vals.listIterator();
					while (itr1.hasNext()) {
						value = (String)itr1.next();
						if (value == null){
							value = "";
						}
						++i;
						//SrNo-1 
						switch(this.getWfType()) {
                            /** 
                             *  Cannot use XMLGenerator's getFloatValue() as using it could result in loss of precision while displaying data.
                             *  In OF, float is represented as NUMERIC(length, precision), RS.getString() can be used on numeric columns. 
                             *  - Varun Bhansaly.
                             **/
							//Bugzilla Bug 5528
							case 8:		/*		
								if(!value.equals("")){
									//Bugzilla Bug 7357
									pos = new ParsePosition(0);
									Date tempdate = formatter.parse(value,pos);
									SimpleDateFormat fr = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", Locale.US);
									value = fr.format(tempdate);
                                }*/
							break;

                            case 15:				
								if(!value.equals("")){
									//Bugzilla Bug 7357
									pos = new ParsePosition(0);
									Date tempdate = formatter.parse(value,pos);
                                                                        if(tempdate==null){
                                                                            if(value.length() ==10){//Postgres case where  no data is getting appended after short data as00.00.00
                                                                                value = value+" 00:00:00.000";
                                                                                tempdate = formatter.parse(value,pos);
                                                                            }
                                                                        }
									SimpleDateFormat fr = new SimpleDateFormat ("yyyy-MM-dd", Locale.US);
									value = fr.format(tempdate);
								}
							break;

                            case 16:
								if(!value.equals("")){
									//Bugzilla Bug 7357
									pos = new ParsePosition(0);
									int dbType = ServerProperty.getReference().getDBType(engineName);
									if(dbType == JTSConstant.JTS_MSSQL||dbType == JTSConstant.JTS_POSTGRES)
										formatter = new SimpleDateFormat ("HH:mm:ss", Locale.US);//Bug 35729
									Date tempdate = formatter.parse(value,pos);
									SimpleDateFormat fr = new SimpleDateFormat ("HH:mm:ss", Locale.US);
									value = fr.format(tempdate);
								}
							break;
						}
                        populateNode(parent, value, fetchAttributeProperty,insertionOrderIdValues);
					}
				}
			} else {
				ArrayList mapsList = this.getListOfMaps();
				//SrNo. 2
				if (mapsList != null) {
//					if (mapsList.size()==0) {
//					xml.append("<"+this.getName()+">"+""+"</"+this.getName()+">\n");
//					} else {
						ListIterator itr = mapsList.listIterator();
                        /** Multiple iterations imply its an array of complex type. - Varun Bhansaly */
						while (itr.hasNext()) {
                            populateNode(parent, value, fetchAttributeProperty);
                            parent = parent.getLastChild();
							LinkedHashMap childValueMap = (LinkedHashMap) itr.next();
							Iterator iter = childValueMap.entrySet().iterator();
							while (iter.hasNext()) {
								Map.Entry entries = (Map.Entry) iter.next();
								WFFieldValue childValue = (WFFieldValue) entries.getValue();
								//WFSUtil.printOut(engineName,childValue.getName()+" = "+childValue.getValues());
                                childValue.serializeAsXML(fieldValueAsXML, parent, engineName, fetchAttributeProperty);
							}
                            if (itr.hasNext()) {
                                /** Now we need to add sibblings to this node. -Varun Bhansaly */
                                parent = parent.getParentNode();
                            }
//						}
					}
				}
			}
		//} catch(Exception ex) {
			//WFSUtil.printErr(engineName,"",ex);
		//}
	 }
     
    /**
     * *******************************************************************
     * Function Name    :   populateNode
     * Programmer' % :   Varun Bhansaly
     * Date Written     :   August 20th 2008
     * Input Parameters :   Node -> parent (This is the node where attributes will be set.)
     *                      String -> value (This is the value (i.e. Text Node) for the Node parent.)
     * Output Parameters:   NONE
     * Return Value     :   NONE
     * Description      :   It populates XML node with attributes and attaches it to its parent node.
     * *******************************************************************
     */ 
     private void populateNode(Node parent, String value, boolean fetchAttributeProperty,ArrayList insertionOrderIdValues) throws Exception {
        Document document = parent.getOwnerDocument();
        String insertionOrderIdValue = "";
        String maxInsertionOrderIdValue = "";
        String minInsertionOrderIdValue = "";
         String sTotalCount = "0";
         String sRetrievedCount = "0";
        Element element = document.createElement(name);
        if(fetchAttributeProperty){
            element.setAttribute("VariableId", variableId + "");
            element.setAttribute("VarFieldId", varFieldId + "");
            if (rightsInfo == null) {
                rightsInfo = "";
            }
            element.setAttribute("Type", rightsInfo + wfType);
            element.setAttribute("Length", length + "");
            if ((insertionOrderIdValues != null) &&(insertionOrderIdValues.size()>0)) {
	            insertionOrderIdValue = (String)insertionOrderIdValues.get(0);
	            maxInsertionOrderIdValue =(String)insertionOrderIdValues.get(1);
	            minInsertionOrderIdValue =(String)insertionOrderIdValues.get(2);
                if (insertionOrderIdValues.size() > 4) {
                    sTotalCount = String.valueOf(insertionOrderIdValues.get(3));
                    sRetrievedCount = String.valueOf(insertionOrderIdValues.get(4));
                }
	          }
            if ((insertionOrderIdValue != null) && (insertionOrderIdValue != "")) {
            	 ((Element)parent).setAttribute("InsertionOrderId", insertionOrderIdValue);
                ((Element)parent).setAttribute("MaxInsertionOrderId", maxInsertionOrderIdValue);
                ((Element)parent).setAttribute("MinInsertionOrderId", minInsertionOrderIdValue);
                if (insertionOrderIdValues.size() > 4) {
                    ((Element) parent).setAttribute("Count", sTotalCount);
                    ((Element) parent).setAttribute("RetrievedCount", sRetrievedCount);
                }
            }
            
            if (wfType == WFSConstant.WF_FLT) {
                element.setAttribute("Precision", precison + "");
            }
            element.setAttribute("isView", isView + "");
        }
       
        if (((insertionOrderIdValues != null) &&(insertionOrderIdValues.size()>0))&&(!fetchAttributeProperty)) {
        	boolean addInsertionOrderIdValue = true;
        	insertionOrderIdValue = (String)insertionOrderIdValues.get(0);
        	NodeList nl = parent.getChildNodes();
        	for (int i = 0; i < nl.getLength(); i++)
        	{
        		if(nl.item(i).getNodeName().equals("InsertionOrderId")){
        			addInsertionOrderIdValue=false;
        			break;
        		}
        	}
        	if(addInsertionOrderIdValue){
        		Element insertionOrderIdElement = document.createElement("InsertionOrderId");
        		insertionOrderIdElement.appendChild(document.createTextNode(insertionOrderIdValue));
        		parent.appendChild(insertionOrderIdElement); 
        	}

        }
        element.appendChild(document.createTextNode(value));
        parent.appendChild(element);
     }
     private void populateNode(Node parent, String value, boolean fetchAttributeProperty) throws Exception {
         Document document = parent.getOwnerDocument();
         Element element = document.createElement(name);
         if(fetchAttributeProperty){
             element.setAttribute("VariableId", variableId + "");
             element.setAttribute("VarFieldId", varFieldId + "");
             if (rightsInfo == null) {
                 rightsInfo = "";
             }
             element.setAttribute("Type", rightsInfo + wfType);
             element.setAttribute("Length", length + "");
             if (wfType == WFSConstant.WF_FLT) {
                 element.setAttribute("Precision", precison + "");
             }
             element.setAttribute("isView", isView + "");
         }
         element.appendChild(document.createTextNode(value));
         parent.appendChild(element);
      }
     private void setInsertionOrderIdValues(ArrayList insertionOrderIdValues) {
    	    this.insertionOrderIdValues = insertionOrderIdValues; }

    	  private ArrayList getInsertionOrderIdValues() {
    	    return this.insertionOrderIdValues;
    	  }
		public String getIsView() {
			return isView;
		}
		public void setIsView(String isView) {
			this.isView = isView;
		}
}