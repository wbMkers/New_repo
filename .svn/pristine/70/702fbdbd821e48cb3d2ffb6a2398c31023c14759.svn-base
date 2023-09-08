/* --------------------------------------------------------------------------
            //                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : iBPS
//                   Module                   :Omniflow Server
//                   File Name                : Parameter.java
//                   Author                   : Ravi Ranjan Kumar
//                   Date written (DD/MM/YYYY): 27/08/2019
//                   Description              : It contain the detail of variable of soap(used in WSDLParser and invoking the web service)
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date           Changed By          Change Description (Bug No. If Any)
 27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import javax.xml.namespace.QName;

public class Parameter
{
	private String name;
	private Integer type;
	private String typeName;
	private boolean isArray;
	private Integer minOccur;
	private boolean nillable;
	private boolean isRef;
	private QName qName;
	private String nameSpaceURL;
	private String inputType;  //If H=Soap Header, I=Soap Body
	private Parameter parent;
	private boolean isRoot;
	private HashMap<String,Parameter> childMap;
	private ArrayList<Parameter> siblingList;
	private ArrayList<String> childNameList;
	private boolean isTypePresent;
	private boolean isRequired;
	
	public Parameter() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Parameter(String name, Integer type, String typeName, boolean isArray) {
		super();
		this.name = name;
		this.type = type;
		this.typeName = typeName;
		this.isArray = isArray;
	}
	public Parameter(String name, Integer type, String typeName, boolean isArray,Integer minOccur,boolean nillable) {
		super();
		this.name = name;
		this.type = type;
		this.typeName = typeName;
		this.isArray = isArray;
		this.minOccur=minOccur;
		this.nillable=nillable;
	}
	public Parameter(String name, Integer type, String typeName, boolean isArray,Integer minOccur,boolean nillable,boolean isRef) {
		super();
		this.name = name;
		this.type = type;
		this.typeName = typeName;
		this.isArray = isArray;
		this.minOccur=minOccur;
		this.nillable=nillable;
		this.isRef=isRef;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public boolean isArray() {
		return isArray;
	}
	public void setArray(boolean isArray) {
		this.isArray = isArray;
	}
	public Integer getMinOccur() {
		return minOccur;
	}
	public void setMinOccur(Integer minOccur) {
		this.minOccur = minOccur;
	}
	public boolean isNillable() {
		return nillable;
	}
	public void setNillable(boolean nillable) {
		this.nillable = nillable;
	}
	public boolean isRef() {
		return isRef;
	}
	public void setRef(boolean isRef) {
		this.isRef = isRef;
	}
	public QName getqName() {
		return qName;
	}
	public void setqName(QName qName) {
		this.qName = qName;
	}
	public String getNameSpaceURL() {
		return nameSpaceURL;
	}
	public void setNameSpaceURL(String nameSpaceURL) {
		this.nameSpaceURL = nameSpaceURL;
	}
	public String getInputType() {
		return inputType;
	}
	public void setInputType(String inputType) {
		this.inputType = inputType;
	}
	public Parameter getParent() {
		return parent;
	}
	public void setParent(Parameter parent) {
		this.parent = parent;
	}
	public boolean isRoot() {
		return isRoot;
	}
	public void setRoot(boolean isRoot) {
		this.isRoot = isRoot;
	}
	public HashMap getChildMap() {
		return childMap;
	}
	public Parameter getChild(String childName){
		if(childMap==null){
			return null;
		}
		return childMap.get(childName);
	}
	public void addChildMap(Parameter child){
		if(childMap==null){
			childMap=new  HashMap<String,Parameter>();
		}
		if(child.getName()!=null){
			childMap.put(child.getName(), child);
			if(!childNameList.contains(child.getName()))
					childNameList.add(child.getName());
		}
	}
	
	public ArrayList<Parameter> getSiblingList() {
		return siblingList;
	}
	public void setSiblingList(ArrayList<Parameter> siblingList) {
		this.siblingList = siblingList;
	}
	
	public void addSibling(Parameter siblingMember){
		if(siblingList==null){
			siblingList=new ArrayList<Parameter>();
		}
		siblingList.add(siblingMember);
	}
	public ArrayList<String> getChildNameList() {
		return childNameList;
	}
//	public void setChildNameList(ArrayList<String> childNameList) {
//		this.childNameList = childNameList;
//	}
	public void setChildMap(HashMap<String, Parameter> childMap) {
		this.childMap = childMap;
		childNameList=new ArrayList<String>();
		Set<String> keySet=childMap.keySet();
		Iterator it=keySet.iterator();
		while(it.hasNext()){
			String tempName=(String) it.next();
			childNameList.add(tempName);
		}
		
	}
	public boolean isTypePresent() {
		return isTypePresent;
	}
	public void setTypePresent(boolean isTypePresent) {
		this.isTypePresent = isTypePresent;
	}
	public boolean isRequired() {
		return isRequired;
	}
	public void setRequired(boolean isRequired) {
		this.isRequired = isRequired;
	}
	
	public void setRequired(){
		setRequired(true);
		if(this.parent!=null){
			this.parent.setRequired();
		}
	}
	
}
