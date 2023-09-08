/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Phoenix
             Product / Project	: Omniflow 7.2
             Module				: Omniflow Server
             File Name			: WFWebServiceHelperUtil.java
             Author				: Varun Bhansaly
             Date written		: 19/05/2008
             Description		: Webservice Helper utility class responsible to simplify
                                  WSDL and generate datastructure jar for complex types.
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 09/06/2008     Varun Bhansaly      1. Case - Operation return/ Output parameters could contain arrays.
                                    2.  I/p parameter       - 'I'
                                        O/p parameter       - 'O'
                                        I/O parameter       - 'B'
                                        Operation Return    - 'R'
                                    3. Case - NPE handled in case ArrayList of members is null
 10/06/2008     Varun Bhansaly      package information to be removed from object's class
 11/06/2008     Varun Bhansaly      Donot consider child nodes for element nodes if it contains 
                                    "ref" attribute or "type" attribute.
 19/06/2008     Varun Bhansaly      Handled XSD types Name, language, ID, IDREF, ENTITY
 27/06/2008     Varun Bhansaly      Bugzilla Id 5434, [SerializeBDO] tagname is className in place of propertyName
 27/06/2008     Varun Bhansaly      Bugzilla Id 5456, [WFSerializeBDO] NullPointerException, value can be null in bdo
 28/06/2008     Varun Bhansaly      Bugzilla Id 5464, Incorrect parameter information for DOC + Literal WebService.
 07/07/2008     Varun Bhansaly      Bugzilla Id 5512, datastructure.jar not created for process having google webservice
 11/07/2008     Varun Bhansaly      Bugzilla Id 5751, Null Pointer Exception in serializeBDO
 28/07/2008     Varun Bhansaly      Bugzilla Id 5888, WSDL is not parsed by WSDL parser
 30/07/2008     Varun Bhansaly      Remove manual steps in datastruct.jar deployment. Implemented fileCopy.
 01/08/2008     Varun Bhansaly      Bugzilla Id 5980, Reserve words like "Name" not supported in complex structures in WSDL
 04/08/2008     Varun Bhansaly      Bugzilla Id 5983, .aar file is not created on registering any process through RD
 06/08/2008     Varun Bhansaly      Bugzilla Id 5986, Parsing Logic fails for this WSDL
 11/08/2008     Varun Bhansaly      For XSD Base types, if it has ref types, use it.
 19/08/2008     Varun Bhansaly      Bugzilla Id 6040, BPEL ? WSDL files currently being thrown in CWD
 08/10/2008     Varun Bhansaly      SrNo-1, Overloaded method serializeBDO - This method will be called by WFWebserviceUtil for 
                                    serialization of BDO, overloading is neccessary for backward compatibility as it has 
                                    other clients also.
                                    signature + accessibility of method setValue() changed.
 08/10/2008     Varun Bhansaly      SrNo-2, method calculatePropertyName to be used to return property name in actual case.
 17/10/2008     Varun Bhansaly      SrNo-3, supoort for XSD duration.
 21/10/2008     Shweta Tyagi        SrNo-4, serializeWFBDOExt(for creating searchXML),setResponseBDO(untested for complex arrays)  
 22/12/2008		Ruhi Hira			Bugzilla Bug 7282, init was not invoked, proxy settings were not initialized.
 02/01/2008     Shilpi S            Bug # 7546
 05/01/2008     Shilpi S            Bug # 7558, Few changes reverted - which were made for Bug # 5986
 05/01/2008     Shilpi S            Bug # 7568
 27/07/2009     Shilpi S            SrNo-5 , Changed the way file location is fetched in any JVM (problem found in jboss5.0.x)
28/05/2010		Preeti Awasthi		WFS_8.0_111: Variable type returned 11 for primitive type variables if they are returned in any complex type variables
 16/07/2010		Preeti Awasthi		WFS_8.0_116: Error comes while executing custom webservice from omniflow if no prefix is used.
 11/08/2010		Saurabh Kamal       Provision of User Credential in case of invoking an authentic webservice
 14/12/2010		Saurabh Kamal		WFS_8.0_116, StringOutOfBound Error in WFWSDLParser 
 08/11/2011     Bhavneet Kaur       Bug 28935- [Webservice] SAXParserException Handled in Uploadworkitem call caused by special characters in XML [Replicated]
 * 05/07/2012   Bhavneet Kaur       Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
 16/08/2012		Preeti Awasthi		Bug 34120 - error in creating workitem from Webservice if complex variables are being set
 13/09/2012		Abhishek Gupta		Bug 34261 - No WSDL path is deployed to the Axis2 module.
 05/02/2013	    Deepti Bachiyani	Bug 38203 - error in webservice inoker call due to encoded password.
 26/02/2013	    Deepti Bachiyani	Bug 38365 - Reverting the changes of bug 38203. Nw handled through WMProcessServer.java
 04/06/2013		Anwar Ali Danish	check added for WSDL operation with blank parameter
 27/08/2019		Ravi Ranjan Kumar	Bug 85671 - Axis 1 to Axis 2 conversion during SOAP execution and Array support in Webservices
 13/07/2020		Ravi Ranjan Kumar	Bug 93264 - IBPS 5 SP1+WBL+Oracle: Error is getting displayed after configuration of BRT workstep
 --------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;

import java.beans.*;
import java.lang.reflect.*;
import java.net.*;
import java.util.*;
import java.util.Map.Entry;
import java.io.*;
import javax.wsdl.*;
import javax.wsdl.extensions.schema.Schema;
import javax.wsdl.extensions.schema.SchemaImport;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;

import org.w3c.dom.*;
import javax.xml.namespace.QName;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPHeader;

//import org.apache.axis.wsdl.gen.Parser;
//import org.apache.axis.wsdl.symbolTable.*;
import org.apache.commons.collections.map.MultiValueMap;
import org.apache.commons.io.FilenameUtils;

//import org.apache.axis.*;
import com.newgen.omni.jts.constt.WFSConstant;
import com.ibm.wsdl.extensions.schema.SchemaImportImpl;
import com.ibm.wsdl.extensions.soap.SOAPBodyImpl;
import com.ibm.wsdl.extensions.soap.SOAPHeaderImpl;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.misc.WFConfigLocator;

public class WFWebServiceHelperUtil {
    /**
     *  A WFBaseType object will represent XSD, containing information such as its corresponding JAVA name, OF type, and whether its an array.
     */
    private static class WFBaseType {
        String XSDName;             /* Name as defined in XSD namespaces. */
        String JAVAName;            /* Corresponding JAVA fully qualified class. */
        int OFTypeId;               /* Corresponding type in OF. */
        boolean unbounded;          /* true - its an array. */
        
        public WFBaseType(String XSDName, String JAVAName, int OFTypeId, boolean unbounded) {
            this.XSDName = XSDName;
            this.JAVAName = JAVAName;
            this.OFTypeId = OFTypeId;
            this.unbounded = unbounded;
        }
    }
    /**
     *  A WFMemberInfo object represents a property of a JAVA class.
     */
    class WFMemberInfo {
        String fieldName;           /* Name of the member. */
        String fieldType;           /* Datatype of the member. */
        int fieldTypeId;            /* Identifier of the Datatype. */
        boolean unbounded;          /* true - its an array. */

        public WFMemberInfo(String fieldName, String fieldType, boolean unbounded) {
            this(fieldName, fieldType, WFSConstant.WF_COMPLEX, unbounded);
        } 
        
        public WFMemberInfo(String fieldName, String fieldType, int fieldTypeId, boolean unbounded) {
            this.fieldName = fieldName;
            this.fieldType = fieldType;
            this.unbounded = unbounded;
            this.fieldTypeId = fieldTypeId; 
            if (!this.isComplexType()) {
                WFBaseType wfBaseType = (WFBaseType)XML2JAVAMap.get(fieldType);
                this.fieldType = wfBaseType.JAVAName;
                if (!this.isArray()) {
                    this.unbounded = wfBaseType.unbounded;
                }
            }
        } 

        public boolean isArray() {
            return unbounded;
        }

        public boolean isComplexType() {
            if (this.fieldTypeId == WFSConstant.WF_COMPLEX) {
                return true;
            } else {
                return false;
            }
        }

        public String getName() {
            return this.fieldName;
        }
        public void setName(String fieldName) {
            this.fieldName = fieldName;
        }

        public String getType() {
            return this.fieldType;
        }
        public void setType(String fieldType) {
            this.fieldType = fieldType;
        }

        public int getfieldTypeId() {
            return this.fieldTypeId;
        }

        public void setfieldTypeId(int fieldTypeId) {
            this.fieldTypeId = fieldTypeId;
        }

        public String toString() {
            StringBuffer member = new StringBuffer();
            member.append("{member Information ## ");
            member.append(" fieldName - " + fieldName);
            member.append(", fieldType - " + fieldType);
            member.append(", fieldTypeId - " + fieldTypeId);
            member.append(", IsArray - " + unbounded);
            member.append("} " + LINE_SEPARATOR);
            return member.toString();
        }
    };

    /**
     *  A WFClassInfo object represents a JAVA class containing information about its superclass & its data members OR properties.
     */
    class WFClassInfo {
        String className;       /* Name of the complex type OR simple type OR Standalone Element. */
        String superClassName;  /* Name of the SuperClass. JAVA doesnot support multiple inheritance. */
        ArrayList members;         /* Data members of the class of type WFMemberInfo. */
        boolean alias;          /* true - No need to generate .java for this type, it has been used for referencing. */

        public WFClassInfo(String superClassName) {
            this.superClassName = superClassName;
        }
        public WFClassInfo(String className, String superClassName, boolean alias, ArrayList members) {
            this.className = className;
            this.superClassName = superClassName;
            this.alias = alias;
            this.members = members;
        }
        public boolean isAlias() {
            return alias;
        }
        public void setAlias(boolean alias) {
            this.alias = alias;
        }

        public String getClassName() {
            return this.className;
        }
        public void setClassName(String className) {
            this.className = className;
        }

        public String getSuperClass() {
            return this.superClassName;
        }
        public void setSuperClass(String superClassName) {
            this.superClassName = superClassName;
        }

        public ArrayList getMembers() {
            return this.members;
        }
        public int getMemberCount() {
            if (members != null) {
                return this.members.size();
            } else {
                return 0;
            }
        }
        public void addMember(WFMemberInfo memberInfo) {
            if (members == null) {
                members = new ArrayList();
            }
            members.add(memberInfo);
        }

        public String toString() {
            StringBuffer classInfo = new StringBuffer();
            classInfo.append("{Class Information ##");
            classInfo.append(" className - " + className);
            classInfo.append(", superClassName - " + superClassName);
            classInfo.append(", memberCount - " + getMemberCount());
            classInfo.append(", members - " + getMembers());
            classInfo.append(", IsAlias - " + alias);
            classInfo.append("}" + LINE_SEPARATOR);
            return classInfo.toString();
        }
    };

    /**
     *  A WFOperationInfo object represents a Webservice operation and information about its Input & Output Parameters.
     */
    private class WFOperationInfo {
        String operationName;   /* Name of the Operation */
        ArrayList parameters;      /* Operation Parameters of type WFParameterInfo */

        public WFOperationInfo(String operationName) {
            this.operationName = operationName;
            this.parameters = null;
        }

        public void addParameter(WFParameterInfo paramInfo) {
            if (this.parameters == null) {
                this.parameters = new ArrayList();
            }
            this.parameters.add(paramInfo);
        }

        public String getOperationName() {
            return this.operationName;
        }
        public int getParameterCount() {
            return this.parameters.size();
        } 

        public ArrayList getParameters() {
            return this.parameters;
        }
    };

    /**
     *  A WFParameterInfo object represents a Webservice operation's parameter.
     */
    private class WFParameterInfo {
        int index;              
        String name;
        int typeId;
        String typeName;
        String scope;               /* I - Input Parameter, O - Output Parameter, B - InOut Parameter. */
        boolean unbounded;          /* true - its an array. */

        public WFParameterInfo(int index, String name, int typeId, String typeName, int scope, boolean unbounded) {
            this.index = index;
            this.name = name;
            this.typeName = typeName;
            this.typeId = typeId;
            this.scope = selectScope(scope);
            this.unbounded = unbounded;
            if (!this.isComplexType()) {
                WFBaseType wfBaseType = (WFBaseType)XML2JAVAMap.get(typeName);
                this.typeName = wfBaseType.JAVAName;
                this.typeId = wfBaseType.OFTypeId;
                if (!this.isArray()) {
                    this.unbounded = wfBaseType.unbounded;
                }
            }
        }

        public int getIndex() {
            return this.index;
        }
        public String getName() {
            return this.name;
        }
        public void setName(String name) {
            this.name = name;
        }

        public int getTypeId() {
            return this.typeId;
        }
        public void setTypeId(int typeId) {
            this.typeId = typeId;
        }

        public String getTypeName() {
            return this.typeName;
        }
        public void setTypeName(String typeName) {
            this.typeName = typeName;
        }

        public String getScope() {
            return this.scope;
        }

        public boolean isArray() {
            return unbounded;
        }
        public void setArray(boolean unbounded) {
            this.unbounded = unbounded;
        }

        public boolean isComplexType() {
            if (this.typeId == WFSConstant.WF_COMPLEX) {
                return true;
            } else {
                return false;
            }
        }

        private String selectScope(int scope) {
            String value = "R";     //RETURN PARAMETER 
            switch(scope) {
                case 1:
                    value = "I";    //IN
                    break;
                case 2:
                    value = "O";    //OUT
                    break;
                case 3:
                    value = "B";    //INOUT
                    break;
            }
            return value;
        }

        public String toString() {
            StringBuffer parameter = new StringBuffer();
            parameter.append("{Parameter Information ##");
            parameter.append(" Name - " + name);
            parameter.append(", TypeName - " + typeName);
            parameter.append(", Index - " + index);
            parameter.append(", TypeId - " + typeId);
            parameter.append(", Scope - " + scope);
            parameter.append(", IsArray - " + unbounded);
            parameter.append("}" + LINE_SEPARATOR);
            return parameter.toString();
        }

    };
//    private class WFSymbolInfo {
//        QName qName;
//        Class clazz;
//        public WFSymbolInfo(QName qName, Class clazz) {
//            this.qName = qName;
//            this.clazz = clazz;
//        }
//        public boolean isElement() {
//            if (this.clazz == org.apache.axis.wsdl.symbolTable.DefinedElement.class) {
//                return true;
//            } else {
//                return false;
//            }
//        }
//        public String toString() {
//            return "{" + qName + ", " + clazz + "}";
//        }
//    };
    private boolean debug = true;
    private static final int COMPILE_SUCCESS = 0;
    public static final String PROP_DEBUG = "Debug";
    public static final String PROP_GENERATE_DATASTRUCTURE = "GenerateDataStructure";
    public static final String CONST_FOLDER_DATASTRUCTURE = "WSTemp";
    private static final String CONST_JAVA_KEYWORD_PACKAGE = "package";
    private static final String CONST_JAVA_KEYWORD_EXTENDS = "extends";
    private static final String CONST_FILE_EXTENSION_JAVA = ".java";
    private static final String CONST_FILE_EXTENSION_JAVA_CLASS = ".class";
    private static final String CONST_JAVAC_PACKAGE = "com.sun.tools.javac.Main";
    private static final String CONST_JAR_PACKAGE = "sun.tools.jar.Main";
    public static final String CONST_DATASTRUCTURE_NAME = "datastruct.jar";
    private static final String CONST_ARRAY = "ArrayOf";
    private static final String FILE_JAVAC_OUTPUT = "compile_error.log";
    private static final String FILE_JAR_OUTPUT = "jar_out.log";
    private static final String FILE_SEPARATOR = System.getProperty("file.separator");
    private static final String LINE_SEPARATOR = System.getProperty("line.separator");
    private static final String QNAME_PREFIX = ">";
    private static final String SEMI_COLON = ":";
    private static final String NS_PREFIX_WSDL = "wsdl";
    private static final String applib = appServerLibLocation();
    static final String XSD_ANYTYPE = "anyType";
    static final String XSD_STRING = "string";
    static final String XSD_NORMALIZEDSTRING= "normalizedString";
    static final String XSD_NMTOKEN = "NMTOKEN";
    static final String XSD_NMTOKENS = "NMTOKENS";
    static final String XSD_TOKEN = "token";
    static final String XSD_BYTE = "byte";
    static final String XSD_UNSIGNEDBYTE = "unsignedByte";
    static final String XSD_BASE64BINARY = "base64Binary";
    static final String XSD_HEXBINARY = "hexBinary";
    static final String XSD_INT = "int";
    static final String XSD_INTEGER = "integer";
    static final String XSD_POSITIVEINTEGER = "positiveInteger";
    static final String XSD_NEGATIVEINTEGER = "negativeInteger";
    static final String XSD_NONPOSITIVEINTEGER = "nonPositiveInteger";
    static final String XSD_NONNEGATIVEINTEGER = "nonNegativeInteger";
    static final String XSD_UNSIGNEDINT = "unsignedInt";
    static final String XSD_BOOLEAN = "boolean";
    static final String XSD_LONG = "long";
    static final String XSD_UNSIGNEDLONG = "unsignedLong";
    static final String XSD_SHORT = "short";
    static final String XSD_UNSIGNEDSHORT = "unsignedShort";
    static final String XSD_DATE = "date";
    static final String XSD_DATETIME = "dateTime";
    static final String XSD_DECIMAL = "decimal";
    static final String XSD_FLOAT = "float";
    static final String XSD_DOUBLE = "double";
    static final String XSD_TIME = "time";
    static final String XSD_QNAME = "QName";
    static final String XSD_ANYURI = "anyURI";
    static final String XSD_NAME = "Name";
    static final String XSD_LANGUAGE = "language";
    static final String XSD_ID = "ID";
    static final String XSD_IDREF = "IDREF";
    static final String XSD_ENTITY = "ENTITY";
    static final String XSD_ANYSIMPLETYPE = "anySimpleType";
	static final String XSD_DURATION = "duration";
    static final String JAVA_CLASS_OBJECT = "java.lang.Object";
    static final String JAVA_CLASS_STRING = "java.lang.String";
    static final String JAVA_CLASS_BYTE = "java.lang.Byte";
    static final String JAVA_CLASS_INTEGER = "java.lang.Integer";
    static final String JAVA_CLASS_LONG = "java.lang.Long";
    static final String JAVA_CLASS_SHORT = "java.lang.Short";
    static final String JAVA_CLASS_BIGDECIMAL = "java.math.BigDecimal";
    static final String JAVA_CLASS_FLOAT = "java.lang.Float";
    static final String JAVA_CLASS_DOUBLE = "java.lang.Double";
    static final String JAVA_CLASS_BOOLEAN = "java.lang.Boolean";
    static final String JAVA_CLASS_DATE = "java.util.Date";
    static final String JAVA_CLASS_CALENDAR = "java.util.Calendar";
    static final String JAVA_CLASS_QNAME = "javax.xml.namespace.QName";
    static final String JAVA_CLASS_ANYSIMPLETYPE = JAVA_CLASS_STRING;
    static final String JAVA_CLASS_ANYURI = "java.net.URI";
    static final String JAVA_CLASS_NAME = JAVA_CLASS_STRING;
    static final String JAVA_CLASS_LANGUAGE = JAVA_CLASS_STRING;
    static final String JAVA_CLASS_ID = JAVA_CLASS_STRING;
    static final String JAVA_CLASS_IDREF = JAVA_CLASS_STRING;
    static final String JAVA_CLASS_ENTITY = JAVA_CLASS_STRING;
	static final String JAVA_CLASS_DURATION = JAVA_CLASS_STRING;
    static final String AXIS_COLLECTION_CLASSNAME = "org.apache.axis.wsdl.symbolTable.CollectionType";
    /* 
       Need to handle cases for duration, gMonth, gYear, gYearMonth, gDay, gMonthDay, IDREFS, ENTITIES, NMTOKENS. 
     */
    private static final String[][] XML2JAVAArray = 
    {
        {XSD_ANYTYPE,             JAVA_CLASS_OBJECT}, 
        {XSD_STRING,              JAVA_CLASS_STRING}, 
        {XSD_NORMALIZEDSTRING,    JAVA_CLASS_STRING}, 
        {XSD_NMTOKEN,             JAVA_CLASS_STRING}, 
        {XSD_NMTOKENS,            JAVA_CLASS_STRING}, 
        {XSD_TOKEN,               JAVA_CLASS_STRING}, 
        {XSD_BYTE,                JAVA_CLASS_BYTE}, 
        {XSD_UNSIGNEDBYTE,        JAVA_CLASS_BYTE}, 
        {XSD_BASE64BINARY,        JAVA_CLASS_BYTE},       //BYTE ARRAY
        {XSD_HEXBINARY,           JAVA_CLASS_BYTE},       //BYTE ARRAY
        {XSD_INT,                 JAVA_CLASS_INTEGER}, 
        {XSD_INTEGER,             JAVA_CLASS_INTEGER}, 
        {XSD_POSITIVEINTEGER,     JAVA_CLASS_INTEGER}, 
        {XSD_NEGATIVEINTEGER,     JAVA_CLASS_INTEGER}, 
        {XSD_NONPOSITIVEINTEGER,  JAVA_CLASS_INTEGER}, 
        {XSD_NONNEGATIVEINTEGER,  JAVA_CLASS_INTEGER}, 
        {XSD_UNSIGNEDINT,         JAVA_CLASS_INTEGER}, 
        {XSD_BOOLEAN,             JAVA_CLASS_BOOLEAN}, 
        {XSD_LONG,                JAVA_CLASS_LONG}, 
        {XSD_UNSIGNEDLONG,        JAVA_CLASS_LONG}, 
        {XSD_SHORT,               JAVA_CLASS_SHORT}, 
        {XSD_UNSIGNEDSHORT,       JAVA_CLASS_SHORT}, 
        {XSD_DATE,                JAVA_CLASS_DATE}, 
        {XSD_DATETIME,            JAVA_CLASS_CALENDAR},  
        {XSD_DECIMAL,             JAVA_CLASS_BIGDECIMAL}, 
        {XSD_FLOAT,               JAVA_CLASS_FLOAT}, 
        {XSD_DOUBLE,              JAVA_CLASS_DOUBLE}, 
        {XSD_TIME,                JAVA_CLASS_DATE},
        {XSD_QNAME,               JAVA_CLASS_QNAME},
        {XSD_ANYSIMPLETYPE,       JAVA_CLASS_ANYSIMPLETYPE},
        {XSD_ANYURI,              JAVA_CLASS_ANYURI},
        {XSD_NAME,                JAVA_CLASS_NAME},
        {XSD_LANGUAGE,            JAVA_CLASS_LANGUAGE},
        {XSD_ID,                  JAVA_CLASS_ID},
        {XSD_IDREF,               JAVA_CLASS_IDREF},
        {XSD_ENTITY,              JAVA_CLASS_ENTITY},
        {XSD_DURATION,            JAVA_CLASS_DURATION}
    }; 

    /** Conversion info. of XML names to JAVA */
    private static final HashMap XML2JAVAMap = populateXML2JAVAMap();
    private static WFWebServiceHelperUtil sharedInstance = new WFWebServiceHelperUtil();
    private static int getFieldValue(String fieldType) {
        int fieldTypeValue = WFSConstant.WF_COMPLEX;   //TYPE_COMPLEX
        if (fieldType.equals(JAVA_CLASS_OBJECT)) {
            fieldTypeValue = WFSConstant.WF_ANY;   //TYPE_ANY
        } else if (fieldType.equals(JAVA_CLASS_STRING)) {
            fieldTypeValue = WFSConstant.WF_STR;   //TYPE_STRING
        } else if (fieldType.equals(JAVA_CLASS_INTEGER)) {
            fieldTypeValue = WFSConstant.WF_INT;    //TYPE_INT
        } else if (fieldType.equals(JAVA_CLASS_SHORT)) {
            fieldTypeValue = WFSConstant.WF_INT;    //TYPE_INT
        } else if (fieldType.equals(JAVA_CLASS_BOOLEAN)) {
            fieldTypeValue = WFSConstant.WF_BOOLEAN;   //TYPE_BOOLEAN
        } else if (fieldType.equals(JAVA_CLASS_BYTE)) {
            fieldTypeValue = 14;
        } else if (fieldType.equals(JAVA_CLASS_LONG)) {
            fieldTypeValue = WFSConstant.WF_LONG;    //TYPE_LONG
        } else if (fieldType.equals(JAVA_CLASS_DATE)) {
            fieldTypeValue = WFSConstant.WF_DAT;    //TYPE_DATE
        } else if (fieldType.equals(JAVA_CLASS_CALENDAR)) {
            fieldTypeValue = WFSConstant.WF_DAT;    //TYPE_DATE
        } else if (fieldType.equals(JAVA_CLASS_BIGDECIMAL)) {
            fieldTypeValue = WFSConstant.WF_LONG;    //TYPE_LONG
        } else if (fieldType.equals(JAVA_CLASS_FLOAT)) {
            fieldTypeValue = WFSConstant.WF_FLT;    //TYPE_FLOAT
        } else if (fieldType.equals(JAVA_CLASS_DOUBLE)) {
            fieldTypeValue = WFSConstant.WF_LONG;    //TYPE_LONG
        } else if(fieldType.equals(JAVA_CLASS_QNAME)) {
            fieldTypeValue = WFSConstant.WF_STR;   //TYPE_STRING
        } else if(fieldType.equals(JAVA_CLASS_ANYURI)) {
            fieldTypeValue = WFSConstant.WF_STR;   //TYPE_STRING
        }
        return fieldTypeValue;
    }

    /**
     * *******************************************************************************
     *      Function Name       : appServerLibLocation
     *      Date Written        : 23/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : String
     *      Return Values       : NONE.
     *      Description         : It calculates app. servers lib path.
     * *******************************************************************************
     */
    public static String appServerLibLocation(){
        URL url = WFWebServiceHelperUtil.class.getProtectionDomain().getCodeSource().getLocation();
        return WFConfigLocator.getInstance().getLibLocation(url);
		//return WFConfigurationLocator.getClassLocation(url);
    }

    /**
     * *******************************************************************************
     *      Function Name       : populateXML2JAVAMap
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : HashMap
     *      Description         : It returns a HashMap which contains the mapping b/w
     *                            datatypes in XSD type system & JAVA datatypes.
     * *******************************************************************************
     */
    private static HashMap populateXML2JAVAMap() {
        HashMap map = new HashMap(XML2JAVAArray.length);
        WFBaseType wfBaseType = null;
        int OFTypeId = 0;
        boolean unbounded = false;
        String XSDName = "", JAVAName = "";
        for(int i = 0; i < XML2JAVAArray.length; i++) {
            unbounded = false;
            XSDName = XML2JAVAArray[i][0];
            JAVAName = XML2JAVAArray[i][1];
            if (XSDName.equals(XSD_BASE64BINARY) || XSDName.equals(XSD_HEXBINARY)) {
                unbounded = true;
            }
            OFTypeId = getFieldValue(JAVAName);
            wfBaseType = new WFBaseType(XSDName, JAVAName, OFTypeId, unbounded);
            map.put(XSDName, wfBaseType);
        }
        return map;
    }

    /**
     * *******************************************************************************
     *      Function Name       : Private Constructor
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceHelperUtil Object
     *      Description         : Constructor.
     * *******************************************************************************
     */
    private WFWebServiceHelperUtil() {
    }

    /**
     * *******************************************************************************
     *      Function Name       : getSharedInstance
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE
     *      Output Parameters   : NONE
     *      Return Values       : WFWebServiceHelperUtil Object
     *      Description         : It returns the shared instance of WFWebServiceHelperUtil.
     * *******************************************************************************
     */
    public static WFWebServiceHelperUtil getSharedInstance() {
        return sharedInstance;
    }

    /**
     * *******************************************************************************
     *      Function Name       : setDebug
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : boolean - debugFlag value
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : setter for debug flag.
     * *******************************************************************************
     */
    public void setDebug(boolean inDebug) {
        System.getProperties().setProperty("http.debug", String.valueOf(inDebug));
        debug = inDebug;
    }

    /**
     * *******************************************************************************
     *      Function Name       : createPackageOnDisc
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : configFolderPath - This points to the location of WFSConfig
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It creates the package structure in the File System and 
     *                            returns the corresponding file Object.
     *                            If WFSConfig is not found, an Exception is thrown
     * *******************************************************************************
     */
    synchronized File createPackageOnDisc(String configFolderPath, String parentFolder, String packageStructure, XMLParser parser) throws Exception {
        File file = new File(configFolderPath);
        String engine = "";
        engine = parser.getValueOf("EngineName");
        if (file.exists() && file.isDirectory()) {
            file = new File(file, parentFolder + FILE_SEPARATOR + packageStructure);
            if (!file.exists() && !file.isDirectory()) {
                dump(parser,"[WFWebServiceHelperUtil] Attempting to create.." + parentFolder + FILE_SEPARATOR + packageStructure);
                boolean check = file.mkdirs();
                if (!check) {
                    WFSUtil.printErr(engine,"[WFWebServiceHelperUtil] Couldnot create " + parentFolder + FILE_SEPARATOR + packageStructure);
                } else {
                    dump(parser,"[WFWebServiceHelperUtil] Successfully created " + parentFolder + FILE_SEPARATOR + packageStructure);
                }
            } else {
                dump(parser,"[WFWebServiceHelperUtil] Package folders exist, no need to create " + parentFolder + FILE_SEPARATOR + packageStructure);
            }
        } else {
            throw new IOException("Omniflow configuration directory " + WFSConstant.CONST_DIRECTORY_CONFIG + " doesnot exist!");
        }
        return file;
    }

    /**
     * *******************************************************************************
     *      Function Name       : getClassLoader
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : NONE.
     *      Output Parameters   : NONE.
     *      Return Values       : ClassLoader.
     *      Description         : It locates tool.jar & registers a URLClassLoader with it.
     *                            This classloader will be used to load JAVA compilation & 
     *                            JAR creation classes located inside it.
     * *******************************************************************************
     */
    private ClassLoader getClassLoader() throws Exception {
        ClassLoader parent = WFWebServiceHelperUtil.class.getClassLoader();
        String tools = System.getProperty("java.home");
        if (tools != null) {
            File file = new File(FilenameUtils.normalize(tools + "/../lib/tools.jar"));
            if (file.exists()) {
                parent = new URLClassLoader(new URL[]{file.toURL()}, parent);
            } else {
                throw new FileNotFoundException("tools.jar couldnot be found in " + tools + ". Possibly JDK Path has not been properly set");
            }
        }
        return parent;
    }

    /**
     * *******************************************************************************
     *      Function Name       : isXSDNode
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. node - XML Node.
     *                            2. schemaLocalName - eg. attribute, complexType, simpleType 
     *      Output Parameters   : NONE.
     *      Return Values       : boolean.
     *      Description         : For <xsd:complexType name="hobbyArray"/>, 
     *                            localName would be complexType.
     *                            This is a helper method using which XML parsing decisions are made.
     * *******************************************************************************
     */
    private boolean isXSDNode(Node node, String schemaLocalName) {
        if (node == null) {
            return false;
        }
        String localName = node.getLocalName();
        if (localName == null) {
            return false;
        }
        return (localName.equals(schemaLocalName));
    }

    /**
     * *******************************************************************************
     *      Function Name       : dump
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : print - Object to be printed
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : If debug is enabled, it prints debug information in debug logs.
     * *******************************************************************************
     */
    private void dump(Object print) {
        if (debug) {
            WFSUtil.printOut("",print);
        }
    }
    private void dump(XMLParser parser, Object print) {
        String engine = "";
        engine = parser.getValueOf("EngineName");
        if (debug) {
            WFSUtil.printOut(engine,print);
        }
    }
     private void dump(String engineName, Object print) {
        if (debug) {
            WFSUtil.printOut(engineName,print);
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : printNodeInfo
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : node - Node for which debug info. has to be generated.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : For the specified node & its children(Element nodes), it prints
     *                            debug information.
     * *******************************************************************************
     */
    public void printNodeInfo(Node node) {
//        dump(" getLocalName      >> " + node.getLocalName());           //      getLocalName >> complexType
//        dump(" getNamespaceURI   >> " + node.getNamespaceURI());        //      getNamespaceURI >> http://www.w3.org/2001/XMLSchema
//        dump(" getNodeName       >> " + node.getNodeName());            //      getNodeName >> xsd:complexType
//        dump(" getNodeValue      >> " + node.getNodeValue());           //      getNodeValue >> null
//        dump(" getPrefix         >> " + node.getPrefix());              //      getPrefix >> xsd
//        dump(" getNodeType       >> " + node.getNodeType());
//        dump(" No. of Child      >> " + node.getChildNodes().getLength());
//        dump(" Child Info,       >> ");
        NodeList kids = node.getChildNodes();
        for(int i = 0; i < kids.getLength(); i++) {
            if(kids.item(i).getNodeType() == Node.ELEMENT_NODE) {
                printNodeInfo(kids.item(i));
            }
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : processChildren
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. className - 
     *                            2. kids - Its a list of children nodes.
     *                            3. class2ClassInfoMap - Its a map of className -> classInfo
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It loops the list, for each ELEMENT_NODE, it passes it to 
     *                            processNode()
     * *******************************************************************************
     */
//    private void processChildren(String className, NodeList kids, HashMap class2ClassInfoMap, Map nameSpaceMap, XMLParser parser) {
//        for(int i = 0; i < kids.getLength(); i++) {
//            /** There may be other #text nodes, which we will ignore. */
//            if (kids.item(i).getNodeType() == Node.ELEMENT_NODE) {
//                processNode(className, kids.item(i), class2ClassInfoMap, nameSpaceMap, parser);
//            }
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : getAttributeValue
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. attribute - eg. type, name, ref etc.
     *                            2. node - Node on which attribute has to be got.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : For <xsd:complexType name="hobbyArray"/>, 
     *                            attribute "name" would be "hobbyArray".
     * *******************************************************************************
     */
    public static String getAttributeValue(String attribute, Node node) {
        Node currentNode = null;
        if(node != null) {
            currentNode = node.getAttributes().getNamedItem(attribute);
            if(currentNode != null) {
                return currentNode.getNodeValue();
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : getLocalPart
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : type - could be for eg. "xsd:string"
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : In XSD or WSDL, references are based on QNames as 
     *                            <xsd:element name="alias" type="xsd:string"/>
     * *******************************************************************************
     */
    private String getLocalPart(String type) {
        /** type will be for eg soap:Array more general would be NS:Type OR xsd:string. */
        if(type != null) {
            int index = type.indexOf(SEMI_COLON);
            if(index > -1) //WFS_8.0_116
				return type.substring(index + 1);
			else 
				return type;
        } else {
            return null;
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : getPrefix
     *      Date Written        : 01/08/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : type - eg. "xsd:string"
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Returns namespace component, for "xsd:string", it returns
     *                            "xsd".
     * *******************************************************************************
     */
    private String getPrefix(String type) {
        /** type will be for eg soap:Array more general would be NS:Type OR xsd:string. */
        if(type != null) {
            int index = type.indexOf(SEMI_COLON);
			if(index > -1)
				return type.substring(0, index);
			else
				return "";
        } else {
            return null;
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : checkNS
     *      Date Written        : 01/08/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : for "xsd:string", prefix - xsd, name - "string", 
     *                            namespaceMap - A map of namespaces defined in the WSDL.
     *      Output Parameters   : NONE.
     *      Return Values       : int.
     *      Description         : Returns simple type if prefix is a shrothand for any of these -
     *                              1. "http://www.w3.org/1999/XMLSchema"
     *                              2. "http://www.w3.org/2000/10/XMLSchema"
     *                              3. "http://www.w3.org/2001/XMLSchema"
     *                            Otherwise, returns complex type.
     * *******************************************************************************
     */
//    private int checkNS(String prefix, String name, Map namespaceMap) {
//        /* Prefix will be empty for default namespace. */
////        if (prefix.equals("") || !namespaceMap.containsKey(prefix) || Constants.isSchemaXSD((String)namespaceMap.get(prefix))) {
////            WFSUtil.printOut(parser,"checkNS().. , what if i remove this check?");
////            return ((WFBaseType)XML2JAVAMap.get(name)).OFTypeId;
////        } else {
////            return WFSConstant.WF_COMPLEX;
////        }
//		//if(prefix.equals("") || (namespaceMap.containsKey(prefix) && Constants.isSchemaXSD((String)namespaceMap.get(prefix)))){
//		if(prefix.equals("") ||(XML2JAVAMap.get(name) != null) ||(namespaceMap.containsKey(prefix) && Constants.isSchemaXSD((String)namespaceMap.get(prefix)))){ //WFS_8.0_111			
//			if (XML2JAVAMap.get(name) != null) {
//				return ((WFBaseType)XML2JAVAMap.get(name)).OFTypeId;
//			}  else {				
//				return WFSConstant.WF_COMPLEX;
//			}
//        }else{
//            return WFSConstant.WF_COMPLEX;
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : processRestrictionNode
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : node - Node to be processed.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : It processes restriction node.
     * *******************************************************************************
     */
//    private WFMemberInfo processRestrictionNode(String parent, Node node, Map namespaceMap) {
//        WFMemberInfo wfMemberInfo = null;
//        String type = "";
//        while (node.hasChildNodes()) {
//            NodeList kids = node.getChildNodes();
//            for(int i = 0; i < kids.getLength(); i++) {
//                /** There may be other #text nodes, which we will ignore. */
//                if (kids.item(i).getNodeType() == Node.ELEMENT_NODE) {
//                    node = kids.item(i);            
//                }
//            }
//        }
//        if (isXSDNode(node, "attribute")) {
//            /** If there is an attribute node, look at wsdl:arrayType to get the element type 
//                The soapenc:arrayType=<qname><dims> is used to determine
//                i) the number of dimensions, 
//                ii) the length of each dimension,
//                iii) the default xsi:type of each of the elements.
//
//                <xsd:complexType name="hobbyArray">
//				    <xsd:complexContent>
//					    <xsd:restriction base="soapenc:Array">
//						    <xsd:attribute ref="soapenc:arrayType" wsdl:arrayType="xsd:string[]"/>
//					    </xsd:restriction>
//    				</xsd:complexContent>
//                </xsd:complexType>
//             **/
//            type = getAttributeValue(NS_PREFIX_WSDL + SEMI_COLON + "arrayType", node);
//            int index = type.indexOf('[');
//            if(index != -1) {
//                type = type.substring(0, index);
//            }
//        } else if (isXSDNode(node, "element")) {
//            /** 
//              <xsd:complexType name="petArray">
//                  <xsd:complexContent>
//                      <xsd:restriction base="soapenc:Array">
//                        <xsd:sequence>
//                          <xsd:element name="alias" type="xsd:string" maxOccurs="unbounded"/>
//                        </xsd:sequence>
//                        </xsd:restriction>
//                  </xsd:complexContent>
//              </xsd:complexType>
//            **/
//            type = getAttributeValue("type", node);
//        }
//        if (!type.equals("")) {
//            String typePrefix = getPrefix(type);
//            type = getLocalPart(type);
//            int typeId = checkNS(typePrefix, type, namespaceMap);
//            wfMemberInfo = new WFMemberInfo(parent, type, typeId, true);
//        }
//        return wfMemberInfo;
//    }

    /**
     * *******************************************************************************
     *      Function Name       : processElementNode
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. parent - parent class name
     *                            2. node - Node to be processed.
     *                            3. class2ClassInfoMap - Its a map of className -> classInfo
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It processes nodes having local part "element".
     *                            These nodes may be either standalone nodes or may further 
     *                            define new types.
     * *******************************************************************************
     */
//    private void processElementNode(String parent, Node node, HashMap class2ClassInfoMap, Map nameSpaceMap, XMLParser parser) {
//        String fieldName = "", fieldType = "", maxOccurs = "", refElement = "", type = "", fieldTypePrefix = "";
//        int fieldTypeId = 0;
//        boolean unbounded = false;
//        WFClassInfo classInfo = null;
//        WFMemberInfo memberInfo = null;
//        NodeList kids = node.getChildNodes();
//        refElement = getAttributeValue("ref", node);
//        fieldType = getAttributeValue("type", node);
//        String engine = "";
//        engine = parser.getValueOf("EngineName");
//        /* If element node conatins a "ref" OR "type" attribute, then its a property declaration.
//           It could still have children nodes, they have to be ignored.
//           Previous code would fail here,
//           <xs:element ref="ItineraryRef">
//                <xs:annotation>
//                    <xs:documentation xml:lang="en">comment</xs:documentation>
//                </xs:annotation>
//            </xs:element>
//           - Varun Bhansaly
//         */
//        if ((refElement == null && fieldType == null) && (node.hasChildNodes() && ((kids.getLength() != 1 && kids.item(0).getNodeType() != Node.TEXT_NODE) || (kids.getLength() == 1 && kids.item(0).getNodeType() != Node.TEXT_NODE) || kids.getLength() > 1 ))) {
//            /*
//                <xs:element name="Status">
//                    <xs:complexType>
//                        <xs:sequence>
//                            <xs:element ref="ns0:StatusCD" />
//                            <xs:element ref="ns0:StatusDesc" />
//                        </xs:sequence>
//                    </xs:complexType>
//                </xs:element>
//            */
//            String className = getAttributeValue("name", node);
//            classInfo = new WFClassInfo(className, null, false, null);
//            if (parent.equals("")) {
//                parent = className;
//            } else {
//                /** CASE - Defn within Defn. */
//                memberInfo = new WFMemberInfo(className, className, false);
//                ((WFClassInfo)(class2ClassInfoMap.get(parent))).addMember(memberInfo);
//            }
//            class2ClassInfoMap.put(className, classInfo);
//            processChildren(className, kids, class2ClassInfoMap, nameSpaceMap, parser);
//        } else {
//            maxOccurs = getAttributeValue("maxOccurs", node);
//            if (refElement != null) {
//                fieldName = getLocalPart(refElement);
//                fieldType = refElement;
//            } else {
//                fieldName = getAttributeValue("name", node);
//                /** Anonymous Type Definition */
//                if (fieldType == null) {
//                    fieldType = XSD_ANYTYPE;
//                }
//            }
//            fieldTypePrefix = getPrefix(fieldType);
//            fieldType = getLocalPart(fieldType);
//            fieldTypeId = checkNS(fieldTypePrefix, fieldType, nameSpaceMap);
//            /** maxOccurs = "unbounded" OR maxOccurs > 1 - indicates there is no maximum number of occurrences. Usually indicates an array */
//            if (maxOccurs != null) {
//                if (maxOccurs.equals("unbounded")) {
//                    unbounded = true;
//                } else {
//                    try {
//                        if (Integer.parseInt(maxOccurs) > 1) {
//                            unbounded = true;
//                        }
//                    } catch (NumberFormatException nfe) {
//                        WFSUtil.printOut(engine,"[WFWebServiceHelperUtil] Encountered NumberFormatException...Ignoring.. " + nfe.getMessage());
//                    }
//                }
//            }
//            memberInfo = new WFMemberInfo(fieldName, fieldType, fieldTypeId, unbounded);
//            if (!parent.equals("")) {
//                ((WFClassInfo)(class2ClassInfoMap.get(parent))).addMember(memberInfo);
//            } else {
//                /** Case - Standalone DefinedElement, usually employed to be replaced. - No need to generated a JAVA file */
//                classInfo = new WFClassInfo(fieldName, null, true, new ArrayList(1));
//                classInfo.addMember(memberInfo);
//                class2ClassInfoMap.put(fieldName, classInfo);
//            }
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : processNode
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. parent - parent class name
     *                            2. node - Node to be processed.
     *                            3. class2ClassInfoMap - Its a map of className -> classInfo
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It process the given node and fills the datastructures as and when reqd.
     *                            Its contains the core decision logic.
     * *******************************************************************************
     */
    /** @@todo Cases not handled - choice, group, attribute(same as element), attributeGroup */
//    private void processNode(String parent, Node node, HashMap class2ClassInfoMap, Map nameSpaceMap, XMLParser parser ) {
//        /**
//         *  complexType can further contain complexType(s)
//         *  Elements that contain subelements or carry attributes are said to have complex types
//         *  Elements that contain numbers (and strings, and dates, etc.) but do not contain any subelements are said to have simple types.
//         *  New simple types are defined by deriving them from existing simple types (built-in's and derived).
//         *  In particular, we can derive a new simple type by restricting an existing simple type, in other words, 
//         *  the legal range of values for the new type are a subset of the 
//         *  existing type's range of values. 
//         *  We use the simpleType element to define and name the new simple type. 
//         *  References - 
//         *  1. http://www.w3.org/TR/wsdl 
//         *  2. http://www.w3schools.com/schema/schema_elements_ref.asp
//         */
//        WFClassInfo classInfo = null;
//        WFMemberInfo memberInfo = null;
//        if (isXSDNode(node, "complexType") || isXSDNode(node, "simpleType")) {
//            NodeList kids = node.getChildNodes();
//            String className = getAttributeValue("name", node);
//            if (parent.equals("")) {
//                parent = className;
//                if(parent != null) {
//                    classInfo = new WFClassInfo(parent, null, false, null);
//                    class2ClassInfoMap.put(parent, classInfo);
//                    processChildren(parent, kids, class2ClassInfoMap, nameSpaceMap, parser);
//                } else {
//                    dump(parser,"No parent...");
//                }
//            } else {
//                if (className != null) {
//                    memberInfo = new WFMemberInfo(className, className, false);
//                	((WFClassInfo)(class2ClassInfoMap.get(parent))).addMember(memberInfo);
//                    classInfo = new WFClassInfo(className, null, false, null);
//                    class2ClassInfoMap.put(className, classInfo);
//                    processChildren(className, kids, class2ClassInfoMap, nameSpaceMap, parser);
//                } else {
//                    processChildren(parent, kids, class2ClassInfoMap, nameSpaceMap, parser);
//                }
//            }
//        } else if(isXSDNode(node, "all") || isXSDNode(node, "sequence") || isXSDNode(node, "complexContent") || isXSDNode(node, "simpleContent")) {
//            NodeList kids = node.getChildNodes();
//            processChildren(parent, kids, class2ClassInfoMap, nameSpaceMap, parser);
//        } else if(isXSDNode(node, "restriction")) {
//            /**
//             * We use the restriction element to indicate the existing (base) type, and to identify the "facets" that constrain the range of values.
//             * The restriction node must have a base of soapenc:Array, xsd:string etc. - These are just aliases
//             */
//            String type = getAttributeValue("base", node);
//            if(type != null) {
//                String typeLocal = getLocalPart(type);
//                if(typeLocal.equals("Array")) {
//                    NodeList kids = node.getChildNodes();
//                    for(int i = 0; i < kids.getLength(); i++) {
//                        /** There may be other #text nodes, which we will ignore. */
//                        if (kids.item(i).getNodeType() == Node.ELEMENT_NODE) {
//                            memberInfo = processRestrictionNode(parent, kids.item(i), nameSpaceMap);
//                            if (memberInfo != null) {
//                                classInfo = (WFClassInfo)(class2ClassInfoMap.get(parent));
//                                classInfo.addMember(memberInfo);
//                                classInfo.setAlias(true);
//                            }
//                        }
//                    }
//                } else {
//                    String typePrefix = getPrefix(type);
//                    int typeId = checkNS(typePrefix, typeLocal, nameSpaceMap);
//                    memberInfo = new WFMemberInfo(parent, typeLocal, typeId, false);
//                    classInfo = (WFClassInfo)(class2ClassInfoMap.get(parent));
//                    classInfo.addMember(memberInfo);
//                    classInfo.setAlias(true);
//                } 
//            }
//        } else if (isXSDNode(node, "extension")) {
//            String baseType = getLocalPart(getAttributeValue("base", node));
//            ((WFClassInfo)(class2ClassInfoMap.get(parent))).setSuperClass(baseType);
//            NodeList kids = node.getChildNodes();
//            processChildren(parent, kids, class2ClassInfoMap, nameSpaceMap, parser);
//        } else if(isXSDNode(node, "attribute")) {
//        } else if(isXSDNode(node, "element")) {
//            processElementNode(parent, node, class2ClassInfoMap, nameSpaceMap, parser);
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : writeFileOnDisc
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. file - .java file to be created.
     *                            2. fileContents - contents to be written.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It generates the .java file and puts filecontents in it.
     * *******************************************************************************
     */
    void writeFileOnDisc(File file, StringBuffer fileContents) throws Exception {
        PrintStream print = null;
        try {
            print = new PrintStream(new FileOutputStream(file));
            print.println(fileContents);
        } finally {
            try {
            	if(print!=null){
            		print.close();
            		print = null;
            	}
            } catch(Exception e) {
            }
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : javaBeansGenerator
     *      Date Written        : 23/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. configFolderPath - Folder where java source and compiled
     *                               classes will be generated.
     *                            2. packageInfo - 
     *                            3. class2ClassInfoMap
     *      Output Parameters   : NONE.
     *      Return Values       : Object[] -> Object[0] ArrayList of java file names,
     *                                        Object[1] ArrayList of java class names.
     *      Description         : It traverses the Map and generates JAVABeans.
     * *******************************************************************************
     */
    Object[] javaBeansGenerator(String configFolderPath, String packageInfo, HashMap class2ClassInfoMap, String engineName) throws Exception {
        WFClassInfo classInfo = null;
        WFMemberInfo memberInfo = null;
        Map.Entry entry = null;
        ArrayList members = null;
        ArrayList javaFileNamesList = new ArrayList();
        ArrayList javaClassNamesList = new ArrayList();
        StringBuffer fileContents = null;
        StringBuffer getter = null;
        String className = "";
        String fieldName = "";
        String dimension = "";
        String superClassName = "";
        String fullPackagePath = packageInfo.replace('.', File.separatorChar);
        String packageHeader = CONST_JAVA_KEYWORD_PACKAGE + " " + packageInfo.substring(0, packageInfo.lastIndexOf('.'));
        File file = null;
        for (Iterator it = class2ClassInfoMap.entrySet().iterator(); it.hasNext(); ) {
            entry = (Map.Entry)it.next();
            classInfo = (WFClassInfo)entry.getValue();
            if (!classInfo.isAlias()) {
                fileContents = new StringBuffer();
                getter = new StringBuffer();
                members = classInfo.getMembers();
                className = (String)entry.getKey();
                dump(engineName,"ClassName >> " + className);
                superClassName = classInfo.getSuperClass();
                if (superClassName != null && !superClassName.equals("")) {
                    superClassName = " " + CONST_JAVA_KEYWORD_EXTENDS + " " + superClassName;
                } else {
                    superClassName = "";
                }
                fileContents.append(packageHeader + ";" + LINE_SEPARATOR + LINE_SEPARATOR);
                fileContents.append("public class " + className + superClassName + " { "  + LINE_SEPARATOR);
                for (int i = 0; i < classInfo.getMemberCount(); i++) {
                    memberInfo = (WFMemberInfo)members.get(i);
                    if (memberInfo.isArray()) {
                        dump(engineName,"FieldName " + memberInfo.fieldName + "  is an array !!");
                        dimension = "[]";
                    } else {
                        dimension = "";
                    }
                    fileContents.append("\tpublic " + memberInfo.fieldType + dimension + " " + memberInfo.fieldName + ";" + LINE_SEPARATOR);
                    fieldName = memberInfo.fieldName;
                    /** Follow JAVA Bean specification */
                    if (Character.isLowerCase(fieldName.charAt(0))) {
                        fieldName = Character.toString(Character.toUpperCase(fieldName.charAt(0))) + fieldName.substring(1);
                    }
                    /* generate getters & setters for field types */
                    getter.append(LINE_SEPARATOR + LINE_SEPARATOR);
                    getter.append("\tpublic " + memberInfo.fieldType + dimension);
                    /** Getter for Boolean boolObject will be getBoolObject() 
                      * Getter for boolean boolVariable will be isBoolVariable() 
                      * - Varun Bhansaly
                     **/
//                    if (memberInfo.fieldType.startsWith("java.lang.Boolean")) {
//                        getter.append(" is");
//                    } else {
                    getter.append(" get");
//                    }
                    getter.append(fieldName + "() {" + LINE_SEPARATOR);
                    getter.append("\t\treturn this." + memberInfo.fieldName + ";" + LINE_SEPARATOR);
                    getter.append("\t}" + LINE_SEPARATOR);

                    getter.append("\tpublic void set" + fieldName + "(" + memberInfo.fieldType + dimension + " " + memberInfo.fieldName + ") {" + LINE_SEPARATOR);
                    getter.append("\t\tthis." + memberInfo.fieldName + " = " + memberInfo.fieldName + ";" + LINE_SEPARATOR);
                    getter.append("\t}");
                }
                javaFileNamesList.add((String)configFolderPath + fullPackagePath + className + CONST_FILE_EXTENSION_JAVA);
                /** Command jar -C dir instructs jar utility to read .class file from directory dir. This should be mentioned for each file. */
                javaClassNamesList.add((String)"-C");
                javaClassNamesList.add((String)configFolderPath);
                javaClassNamesList.add((String)fullPackagePath + className + CONST_FILE_EXTENSION_JAVA_CLASS);
                fileContents.append(getter);
                fileContents.append(LINE_SEPARATOR + "}");
                file = new File(configFolderPath, fullPackagePath + className + CONST_FILE_EXTENSION_JAVA);
                writeFileOnDisc(file, fileContents);
                fileContents = null;
                getter = null;
            } 
        }
        return new Object[] {javaFileNamesList, javaClassNamesList};
    }

    /**
     * *******************************************************************************
     *      Function Name       : javaBeansCompiler
     *      Date Written        : 23/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. configFolderPath - Folder where compile log will be created.
     *                            2. javaFileNamesList - file with fully qualified package to be conpiled.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Loads & locates JAVA compiler tool to compile java files.
     * *******************************************************************************
     */
    synchronized void javaBeansCompiler(String configFolderPath, ArrayList javaFileNamesList, String engineName) throws Exception {
        /* Specify where to find input source files */
    	PrintWriter outCompile=null;
    	try{
    		double major=Double.parseDouble(System.getProperty("java.class.version"));
			if(major>52){
				javaFileNamesList.add(0,(String)"-classpath");
	            javaFileNamesList.add(1, (String)applib+"wfwebserviceshared.jar");
			}else{
				javaFileNamesList.add(0, (String)"-sourcepath");
		        javaFileNamesList.add(1, (String)configFolderPath);
		        /* location of library. Each JAR archive in the specified directories is searched for class files. */
		        javaFileNamesList.add(2, (String)"-extdirs");
		        javaFileNamesList.add(3, (String)applib);
			}
        
        String[] javaFileNamesArray = new String[javaFileNamesList.size()];
         outCompile = new PrintWriter(new FileOutputStream(configFolderPath + FILE_JAVAC_OUTPUT, true));
         Class clazz=null;
         if(major>52){
        	 clazz = Class.forName(CONST_JAVAC_PACKAGE);
        }else{
        	 ClassLoader classLoader = getClassLoader();
             clazz = Class.forName(CONST_JAVAC_PACKAGE, true, classLoader);
        }
        
        javaFileNamesList.toArray(javaFileNamesArray);
        printArray(javaFileNamesArray, engineName);
        int status = ((Integer)clazz.getMethod("compile", new Class[] {String[].class, PrintWriter.class}).invoke(null, new Object[] {javaFileNamesArray, outCompile})).intValue();
        if (status == COMPILE_SUCCESS) {
            dump(engineName,"[WFWebServiceHelperUtil] [javaBeansCompiler].. congratulations!! compilation successful.");
        } else {
            dump(engineName,"[WFWebServiceHelperUtil][javaBeansCompiler].. oops exception occured while compiling, hence jar could not be created.");
            throw new Exception("exception occured while compiling, hence jar could not be created.");
        }}finally{
        	try{
        		if(outCompile!=null){
        			outCompile.close();
        			outCompile=null;
        		}
        	}catch(Exception e){
        		WFSUtil.printErr(engineName,"",e);
        	}
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : buildArchive
     *      Date Written        : 23/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. configFolderPath - Folder where compile log will be created.
     *                            2. archiveName - archive name.
     *                            3. javaClassNamesList - file with fully qualified package to be archived.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : Loads & locates JAVA jar creation tool to build archive.
     * *******************************************************************************
     */
    synchronized void buildArchive(String configFolderPath, String archiveName, ArrayList javaClassNamesList, String engineName) throws Exception {
    	PrintStream outJAR=null;
    	try{
    		double major=Double.parseDouble(System.getProperty("java.class.version"));
    	File jarFile = new File(configFolderPath + archiveName);
        if (jarFile.exists()) {
            javaClassNamesList.add(0, (String)"uf");
        } else {
            javaClassNamesList.add(0, (String)"cf");
        }
        javaClassNamesList.add(1, (String)configFolderPath + (String)archiveName);
        String[] javaClassNamesArray = new String[javaClassNamesList.size()];
        javaClassNamesList.toArray(javaClassNamesArray);
        printArray(javaClassNamesArray, engineName);
        outJAR = new PrintStream(new FileOutputStream(configFolderPath + FILE_JAR_OUTPUT), true);
   	 	Class clazz=null;
        if(major>52){
        	  clazz = Class.forName(CONST_JAR_PACKAGE);
        }else{
        	ClassLoader classLoader = getClassLoader();
             clazz = Class.forName(CONST_JAR_PACKAGE, true, classLoader);
        }
        
        Constructor constructor = clazz.getConstructor(new Class[] {PrintStream.class, PrintStream.class, String.class});
        Object object = constructor.newInstance(new Object[] {outJAR, outJAR, "jar"});
        /* This is itself a synchronized method - Varun Bhansaly */
        boolean state = ((Boolean)clazz.getMethod("run", new Class[]{String[].class}).invoke(object, new Object[] {javaClassNamesArray})).booleanValue();
        if (!state) {
            dump(engineName,"[WFWebServiceHelperUtil][buildArchive].. oops exception occured while creating " + archiveName);
            throw new Exception("exception occured while creating " + archiveName);
        } else {
            dump(engineName,"[WFWebServiceHelperUtil][buildArchive].. congratulations!! jar creation successful.");
        }}finally{
    		try{
    			if(outJAR!=null){
    				outJAR.close();
    				outJAR=null;
    			}
    		}catch(Exception e){
    			WFSUtil.printErr("", e);
    		}
    	}
    }


    /**
     * *******************************************************************************
     *      Function Name       : generateDS
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. configFolderPath - Location where datastructure jar has to be placed.
     *                            2. javaFileNames - .java files to be compiled.
     *                            3. classFileNames - .class files to be embedded in jar.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It is responsible for loading the java compilation 
     *                            classes & jar creation classes.
     *                            It compiles .java files & puts .class in jar 
     * *******************************************************************************
     */
     void generateDS(String configFolderPath, String archiveName, ArrayList javaFileNamesList, ArrayList classFileNamesList, XMLParser parser) throws Exception {
        javaBeansCompiler(configFolderPath, javaFileNamesList, parser.getValueOf("EngineName"));
        String engine = "";
        engine = parser.getValueOf("EngineName");
        String src = appServerLibLocation() + CONST_DATASTRUCTURE_NAME;
        String dest = configFolderPath + CONST_DATASTRUCTURE_NAME;
        try {
            fileCopy(src, dest, parser.getValueOf("EngineName"));
        } catch (Exception ignore) {
            WFSUtil.printErr(engine, "[WFWebServiceHelperUtil] ... ignoring copy failure from " + src + " to " + dest);
        }
        buildArchive(configFolderPath, archiveName, classFileNamesList,parser.getValueOf("EngineName"));
        try {
            fileCopy(dest, src, parser.getValueOf("EngineName"));
        } catch (Exception e) {
            WFSUtil.printErr(engine,"[WFWebServiceHelperUtil] ... ", e);
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : fileCopy
     *      Date Written        : 30/07/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. src - source from where file is to be copied.
     *                            2. dest - destination to which file is to be copied.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It copies file contents from one location to another.
     * *******************************************************************************
     */
    void fileCopy(String src, String dest, String engineName) throws Exception {
        FileInputStream input = null;
		FileOutputStream output = null;
        try {
            dump(engineName,"[WFWebServiceHelperUtil] Source -> " + src);
            dump(engineName,"[WFWebServiceHelperUtil] Destination -> " + dest);
            input = new FileInputStream(src);
            output = new FileOutputStream(dest);
            byte[] buffer = new byte[1024];
            int read = 0;
            read = input.read(buffer);
            while (read > 0) {
                output.write(buffer, 0, read);
                read = input.read(buffer);
            }
        } finally {
            if (input != null) {
                try {
                    input.close();
                    input = null;
                } catch (Exception ignore) {}
            }
            if (output != null) {
                try {
                    output.close();
                    output = null;
               } catch (Exception ignore) {}
            }
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : resolveReferences
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : class2ClassInfoMap
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It detects and removes all referenced aliases. 
     *                            Its sort of a second pass.
     * *******************************************************************************
     */
    private void resolveReferences(HashMap class2ClassInfoMap, XMLParser parser) {
        Map.Entry entry = null;
        ArrayList members = null;
        WFClassInfo classInfo = null;
        WFClassInfo tempClassInfo = null;
        WFMemberInfo memberInfo = null;
        int index = -1;
        for(Iterator it = class2ClassInfoMap.entrySet().iterator(); it.hasNext();) {
            entry = (Map.Entry)it.next();
            classInfo = (WFClassInfo)entry.getValue();
            members = classInfo.getMembers();
            if (classInfo.getClassName().startsWith(CONST_ARRAY)) {
                /* Use the name ArrayOfXXX for array types (where XXX is the type of the items in the array) - WSDL specs 
                   No need to create a .java for the same. Hence its made an alias.
                 **/
                classInfo.setAlias(true);
            }
            dump(parser,"[ClassInfo] " + classInfo);

            for (int i = 0; i < classInfo.getMemberCount(); i++) {
                memberInfo = (WFMemberInfo)members.get(i);
                if (class2ClassInfoMap.containsKey(memberInfo.fieldType)) {
                    tempClassInfo = (WFClassInfo)class2ClassInfoMap.get(memberInfo.fieldType);
                    dump(parser,"[TempClassInfo] " + tempClassInfo);
                    if (tempClassInfo.getClassName().startsWith(CONST_ARRAY)) {
                        /* Use the name ArrayOfXXX for array types (where XXX is the type of the items in the array) - WSDL specs 
                           No need to create a .java for the same. Hence its made an alias.
                         **/
                        tempClassInfo.setAlias(true);
                    }
                    if (tempClassInfo.isAlias()) {
                        WFMemberInfo temp = (WFMemberInfo)(tempClassInfo.getMembers().get(0));
                        dump(parser,tempClassInfo.getClassName() + " is an Alias!!");
                        memberInfo.fieldType = temp.fieldType;
                        memberInfo.fieldTypeId = temp.fieldTypeId;
                        if (XML2JAVAMap.containsKey(memberInfo.fieldType)) {
                            memberInfo.setType((String)XML2JAVAMap.get(memberInfo.fieldType)); 
                        }
                        memberInfo.unbounded = temp.unbounded;
                    }
                }   
                dump(parser,"[MemberInfo] " + memberInfo);
            }
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : javifyMap
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : class2ClassInfoMap
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : It traverses the map and generates .java files. 
     * *******************************************************************************
     */
    private void javifyMap(HashMap class2ClassInfoMap, XMLParser parser) throws Exception {
        String configFolderPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + FILE_SEPARATOR;
        String packageStructure = WFWebServiceUtil.OMNI_COMPLEX_STRUCTURE_PACKAGE.replace('.', File.separatorChar);
        String wsdl = parser.getValueOf("WSDLLocation");
		String tempPathStr = wsdl.substring((wsdl.lastIndexOf("/") + 1) ,wsdl.lastIndexOf("?"));
		if(tempPathStr.contains(".")){
			tempPathStr = tempPathStr.substring(0,tempPathStr.indexOf("."));
		}
        packageStructure = packageStructure + tempPathStr + File.separatorChar;
        ArrayList javaFileNamesList = null;
        ArrayList javaClassNamesList = null;
        Object[] result = null;
        String engine = "";
        engine = parser.getValueOf("EngineName");
        dump(parser,"The Map >>\n" + class2ClassInfoMap);
        File file = createPackageOnDisc(configFolderPath, CONST_FOLDER_DATASTRUCTURE, packageStructure, parser);
        configFolderPath = configFolderPath + CONST_FOLDER_DATASTRUCTURE + FILE_SEPARATOR;		
        result = javaBeansGenerator(configFolderPath, (WFWebServiceUtil.OMNI_COMPLEX_STRUCTURE_PACKAGE + tempPathStr + "."), class2ClassInfoMap,parser.getValueOf("EngineName"));
        javaFileNamesList = (ArrayList)result[0];
        javaClassNamesList = (ArrayList)result[1];
        if (javaFileNamesList.size() > 0) {
            generateDS(configFolderPath, CONST_DATASTRUCTURE_NAME, javaFileNamesList, javaClassNamesList, parser);
        } else {
            WFSUtil.printOut(engine,"Check! Check! No files to compile. size() >> " + javaFileNamesList.size());
        }
    }

    private void printArray(String[] javaNamesArray, String engineName) {
        for (int j = 0; j < javaNamesArray.length; j++) {
            dump(engineName,"Array[" + j + "] - " + javaNamesArray[j]);
        }
    }

    /**
     * *******************************************************************************
     *      Function Name       : parseWSDL
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. symbolTable - axis generated symbolTable.
     *                            2. QNames - Set containg types referenced in messages. 
     *      Output Parameters   : NONE.
     *      Return Values       : HashMap.
     *      Description         : It traverses the Set and calls processNode for each typeEntry.
     * *******************************************************************************
     */
//    private HashMap parseWSDL(SymbolTable symbolTable, HashSet QNames, XMLParser parser) throws Exception {
//        Map nameSpaceMap = symbolTable.getDefinition().getNamespaces();
//        //dump(parser,"The Map of Namespaces - " + nameSpaceMap);
//		//dump(parser,"The Defs >> " + symbolTable.getDefinition());
//        //dump(parser,"The Types >> " + symbolTable.getDefinition().getTypes());
//        /** This is a collection of symbols actually referenced in the WSDL. - Varun Bhansaly */
//        dump(parser,"The Collection of Symbols - " + QNames);
//        /** Stores mapping of classnames and its description. */
//        HashMap class2ClassInfoMap = new HashMap();
//        /** Stores mapping of classnames and information related to the class. - eg. Inheritance info. */
//        /** Stores mapping of aliasnames and its types - eg. 
//            <xsd:simpleType name="UsernameType">
//                <xsd:restriction base="xsd:string">
//                    <xsd:minLength value="4" />
//                    <xsd:pattern value="[A-Za-z0-9]+" />
//                </xsd:restriction>
//            </xsd:simpleType>
//          * - here aliasname -> UsernameType & type -> string
//         **/
//        String qNameLocalPart = null;
//        Node typeEntryNode = null;
//        TypeEntry typeEntry = null;
//        for (Iterator QNamesIterator = QNames.iterator(); QNamesIterator.hasNext(); ) {
//            WFSymbolInfo wfSymbolInfo = (WFSymbolInfo)QNamesIterator.next(); 
//            typeEntry = symbolTable.getTypeEntry(wfSymbolInfo.qName, wfSymbolInfo.isElement());
//            if (typeEntry != null && !(typeEntry instanceof BaseType) && !(typeEntry instanceof CollectionType) && !(typeEntry instanceof CollectionElement) && (typeEntry instanceof DefinedType || typeEntry instanceof DefinedElement)) {
//                qNameLocalPart = Utils.getLastLocalPart(typeEntry.getQName().getLocalPart());
//                if (!(class2ClassInfoMap.containsKey(qNameLocalPart))) {
//                    typeEntryNode = typeEntry.getNode();
//                    WFClassInfo wfClassInfo = new WFClassInfo(qNameLocalPart, null, typeEntry.isBaseType(), null);
//                    /*Bug # 7558*/
//                    //class2ClassInfoMap.put(qNameLocalPart, wfClassInfo);
//                    //processNode(qNameLocalPart, typeEntryNode, class2ClassInfoMap, nameSpaceMap);
//                   processNode("", typeEntryNode, class2ClassInfoMap, nameSpaceMap, parser);
//                } 
//            }
//        }
//        resolveReferences(class2ClassInfoMap, parser);
//        return class2ClassInfoMap;
//    }

    /**
     * *******************************************************************************
     *      Function Name       : getSymTabEntry
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. symbolTable - axis generated symbolTable.
     *                            2. cls - class, eg. ServiceEntry.class, TypeEntry.class
     *      Output Parameters   : NONE.
     *      Return Values       : SymTabEntry.
     *      Description         : Utility method to symbolTbale entry corresponding to cls
     * *******************************************************************************
     */
//    private SymTabEntry getSymTabEntry(SymbolTable symbolTable, Class cls) {
//        HashMap map = symbolTable.getHashMap();
//        Iterator iterator = map.entrySet().iterator();
//        Map.Entry entry = null;
//        while (iterator.hasNext()) {
//            entry = (Map.Entry) iterator.next();
//            Vector v = (Vector) entry.getValue();
//            for (int i = 0; i < v.size(); ++i) {
//                SymTabEntry symTabEntry = (SymTabEntry) v.elementAt(i);
//                if (cls.isInstance(symTabEntry)) {
//                    return symTabEntry;
//                }
//            }
//        }
//        return null;
//    }

    /**
     * *******************************************************************************
     *      Function Name       : selectService
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : symbolTable - axis generated symbolTable.
     *      Output Parameters   : NONE.
     *      Return Values       : Service.
     *      Description         : Browse the symbolTable and extract from it entry corresponding to ServiceEntry
     * *******************************************************************************
     */
//    private Service selectService(SymbolTable symbolTable) {
//        ServiceEntry serviceEntry = (ServiceEntry) getSymTabEntry(symbolTable, ServiceEntry.class);
//        return serviceEntry.getService();
//    }

    /**
     * *******************************************************************************
     *      Function Name       : addQName
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. entry - axis generated typeEntry
     *                            2. QNames - Set of QNames.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : This method adds in the Set referenced TypeEntry's QName.
     * *******************************************************************************
     */
//    private void addQName(TypeEntry entry, HashSet QNames, XMLParser parser) {
//        /** As an optimization donot add baseType entries. - Varun Bhansaly */
//        if (!(entry instanceof BaseType)) {
//            WFSymbolInfo wfSymbolInfo = new WFSymbolInfo((QName)entry.getQName(), entry.getClass());
//            QNames.add(wfSymbolInfo);
//            dump(parser,"Attempting to add - " + wfSymbolInfo);
//            TypeEntry refType = entry.getRefType();
//            if (refType != null) {
//                addQName(refType, QNames, parser);
//            } else {
//                dump(parser,"No Ref Types for - " + wfSymbolInfo);
//            }
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : selectParameter
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. index - Parameter Index.
     *                            2. parameter - axis parameter object.
     *                            3. QNames - Set of QNames identifying referred types & elements.
     *                            4. symbolTable - axis generated symbolTable.
     *      Output Parameters   : NONE.
     *      Return Values       : WFParameterInfo
     *      Description         : For a given axis parameter, generate WFParameterInfo object & return it.
     * *******************************************************************************
     */
//    private WFParameterInfo selectParameter(int index, int paramScope, Parameter parameter, HashSet QNames, SymbolTable symbolTable, XMLParser parser) {
//        TypeEntry entry = parameter.getType();
//        int typeId = WFSConstant.WF_COMPLEX;
//        String type = null;
//        boolean unbounded = false;
//        if (entry != null) {
//            /** QName of a Collection type is {Namespace}LocalPart[0, unbounded] and it refers {Namespace}LocalPart */
//            if (parameter.getType() instanceof org.apache.axis.wsdl.symbolTable.CollectionType) {
//                dump(parser,"Parameter is an array...Extracting its type..." + parameter);
//                entry = entry.getRefType();
//                unbounded = true;
//            }
//            addQName(entry, QNames, parser);
//            HashSet nestedTypes = entry.getNestedTypes(symbolTable, true);
//            for (Iterator nestedTypesIterator = nestedTypes.iterator(); nestedTypesIterator.hasNext(); ) {
//                addQName((TypeEntry)nestedTypesIterator.next(), QNames, parser);
//            }
//            if (entry.isBaseType()) {
//                typeId = WFSConstant.WF_ANY;
//                if (entry.getRefType() != null) {
//                    entry = entry.getRefType();
//                }
//            } else {
//                dump(parser,"[selectParameter] parameter is not base ...");
//            }
//            type = Utils.getLastLocalPart(entry.getQName().getLocalPart());
//        } else {
//            dump(parser,"entry is null !!");
//        }
//        WFParameterInfo wfParameterInfo = new WFParameterInfo(index, parameter.getName(), typeId, type, paramScope, unbounded);
//        dump(parser,wfParameterInfo);
//        return wfParameterInfo;
//    }

    /**
     * *******************************************************************************
     *      Function Name       : selectBindingEntry
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. bEntry - axis generated BindingEntry.
     *                            2. symbolTable - axis generated SymbolTable.
     *                            3. QNames - Set of QNames.
     *                            4. operatins - list of operations.
     *      Output Parameters   : NONE.
     *      Return Values       : NONE.
     *      Description         : For a BindingEntry, extract its Operations and Parameters.
     * *******************************************************************************
     */
//    private void selectBindingEntry(BindingEntry bEntry, SymbolTable symbolTable, HashSet QNames, HashMap operations, XMLParser parser) {
//        Map.Entry entry = null;
//        Map map = bEntry.getParameters();
//        WFOperationInfo operationInfo = null;
//        WFParameterInfo parameterInfo = null;
//        int i = 0;
//        for (Iterator mapIterator = map.entrySet().iterator(); mapIterator.hasNext(); ) { 
//            entry = (Map.Entry)mapIterator.next();      // com.ibm.wsdl.OperationImpl -> org.apache.axis.wsdl.symbolTable.Parameters
//            Operation operation = (Operation)entry.getKey();
//            String operName = operation.getName();
//            operationInfo = new WFOperationInfo(operName);
//            Parameters parameters = bEntry.getParameters(operation); 
//            dump(parser,"OperationName >> " + operName);
//            Parameter parameter = null;
//            dump(parser,"Operation has ParameterCount >> " + parameters.list.size());
//            for (i = 0; i < parameters.list.size(); ) {
//                parameter = (Parameter)parameters.list.elementAt(i);
//                parameterInfo = selectParameter(++i, parameter.getMode(), parameter, QNames, symbolTable, parser);
//                operationInfo.addParameter(parameterInfo);
//            }
//            if (parameters.returnParam != null) {
//                parameterInfo = selectParameter(++i, -1, parameters.returnParam, QNames, symbolTable, parser);
//                operationInfo.addParameter(parameterInfo);
//            } else {
//                dump(parser,"Operation has no return parameters ...");
//            }
//            
//            if(!operations.containsKey(operationInfo.getOperationName())){
//                operations.put(operationInfo.getOperationName(), (WFOperationInfo)operationInfo);
//            }
//        }
//    }

    
    /**
     * *******************************************************************************
     *      Function Name       : convertWSDL
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : propMap - Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : This method will be called by the client, passing to it 
     *                            inputs configuration in the form of a hashmap.
     * *******************************************************************************
     */
    // @@todo Set debug ON OFF in Singleton pattern ???.
//    public String convertWSDL(HashMap propMap, XMLParser parser) throws Exception {
//        boolean generateDS = false;
//        boolean proxyEnabled = false;
//        String engine = "";
//        engine = parser.getValueOf("EngineName");
//        String WSDLPath = (String)propMap.get(WFWebServiceUtil.PROP_WSDLLOCATION);
//        String proxyUser = (String)propMap.get(WFWebServiceUtil.PROP_PROXYUSER);
//        String proxyPass_word = (String)propMap.get(WFWebServiceUtil.PROP_PROXYPASSWORD);
//        String proxyHost = (String)propMap.get(WFWebServiceUtil.PROP_PROXYHOST);
//        String proxyPort = (String)propMap.get(WFWebServiceUtil.PROP_PROXYPORT);
//        String proxyEnabledStr = (String)propMap.get(WFWebServiceUtil.PROP_PROXYENABLED);
//        String debugStr = (String)propMap.get(WFWebServiceHelperUtil.PROP_DEBUG);
//        String generateDSStr = (String)propMap.get(WFWebServiceHelperUtil.PROP_GENERATE_DATASTRUCTURE);
//		String basicAuthUser = (String)propMap.get(WFWebServiceUtil.PROP_BASICAUTH_USER);
//        String basicAuthP_wd = (String)propMap.get(WFWebServiceUtil.PROP_BASICAUTH_PASSWORD);
//        if (debugStr != null && debugStr.trim().equalsIgnoreCase("True")) {
//            setDebug(true);
//            WFWebServiceUtil.setDebug(true);
//        } else {
//            setDebug(false);
//            WFWebServiceUtil.setDebug(false);
//        }
//        if (generateDSStr != null && generateDSStr.trim().equalsIgnoreCase("True")) {
//            generateDS = true;
//        }
//        if (proxyEnabledStr != null && proxyEnabledStr.equalsIgnoreCase("True")) {
//            proxyEnabled = true;
//        } else {
//            proxyEnabled = false;
//        }
//        Parser wsdlParser = new Parser();
//        WSDLPath = WFSUtil.resolveWSDLPath(WSDLPath,engine);
//        File f = new File(WSDLPath);
//        try {
//            if (f.exists()) {
//                WSDLPath = f.toURL().toString();
//                dump(parser,"[WFWebServiceHelperUtil] WSDLPath - " + WSDLPath);
//            } else {
//                dump(parser,"[WFWebServiceHelperUtil] File doesnot exist, may be its a http(s) URL...");
//            }
//        } catch (Exception e) {
//            WFSUtil.printErr(engine,"[WFWebServiceHelperUtil] - ", e);
//        }
//        if (proxyEnabled && !f.isFile()) {
//			/** 22/12/2008, Bugzilla Bug 7282, init was not invoked, proxy settings were not initialized - Ruhi Hira */
//            WFWebServiceUtil.init(propMap, parser.toString());
//            wsdlParser.setUsername(basicAuthUser);
//            wsdlParser.setPassword(basicAuthP_wd);
//        }
//        wsdlParser.run(WSDLPath);
//        SymbolTable symbolTable = wsdlParser.getSymbolTable();
 //       return convertWSDL(symbolTable, generateDS, parser);
//    }
//    
    private  String verifyString (String value)
   	{
       	String output=value;
   		try
   		{
   			output = String.valueOf(Integer.parseInt(value)); 
   		}
   		catch (Exception e)
   		{
   			
   		}
   		
   		return output;
   		
   	}
    
    /**
     * *******************************************************************************
     *      Function Name       : convertWSDL
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : HashMap propMap, XMLParser parser
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Its Read the wsdl and simplify the WSDL Document
     * *******************************************************************************
     */
    public String convertWSDL(HashMap propMap, XMLParser parser) throws Exception {
        boolean generateDS = false;
        boolean proxyEnabled = false;
        String engine = "";
        engine = parser.getValueOf("EngineName");
        String WSDLPath = (String)propMap.get(WFWebServiceUtil.PROP_WSDLLOCATION);
		WSDLPath = WFSUtil.TO_SANITIZE_STRING(WSDLPath, true);
        String proxyUser = (String)propMap.get(WFWebServiceUtil.PROP_PROXYUSER);
        String proxyPass_word = (String)propMap.get(WFWebServiceUtil.PROP_PROXYPA_SS_WORD);
        String proxyHost = (String)propMap.get(WFWebServiceUtil.PROP_PROXYHOST);
        String proxyPort = (String)propMap.get(WFWebServiceUtil.PROP_PROXYPORT);
        String proxyEnabledStr = (String)propMap.get(WFWebServiceUtil.PROP_PROXYENABLED);
        String debugStr = (String)propMap.get(WFWebServiceHelperUtil.PROP_DEBUG);
        String generateDSStr = (String)propMap.get(WFWebServiceHelperUtil.PROP_GENERATE_DATASTRUCTURE);
		String basicAuthUser = (String)propMap.get(WFWebServiceUtil.PROP_BASICAUTH_USER);
        String basicAuth_P_wd = (String)propMap.get(WFWebServiceUtil.PROP_BASICAUTH_PA_SS_WORD);
        
        if (debugStr != null && debugStr.trim().equalsIgnoreCase("True")) {
            setDebug(true);
            WFWebServiceUtil.setDebug(true);
        } else {
            setDebug(false);
            WFWebServiceUtil.setDebug(false);
        }
        if (generateDSStr != null && generateDSStr.trim().equalsIgnoreCase("True")) {
            generateDS = true;
        }
        if (proxyEnabledStr != null && proxyEnabledStr.equalsIgnoreCase("True")) {
            proxyEnabled = true;
        } else {
            proxyEnabled = false;
        }
        WSDLPath = WFSUtil.resolveWSDLPath(WSDLPath,engine);
        WSDLFactory factory=WSDLFactory.newInstance();
        WSDLReader reader=factory.newWSDLReader();
        WSDLPath=verifyString(WSDLPath);
        File f = new File(FilenameUtils.normalize(WSDLPath));
        try {
            if (f.exists()) {
                WSDLPath = f.toURL().toString();
                dump(parser,"[WFWebServiceHelperUtil] WSDLPath - " + WSDLPath);
            } else {
                dump(parser,"[WFWebServiceHelperUtil] File doesnot exist, may be its a http(s) URL...");
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"[WFWebServiceHelperUtil] - ", e);
        }
        if (proxyEnabled && !f.isFile()) {
			/** 22/12/2008, Bugzilla Bug 7282, init was not invoked, proxy settings were not initialized - Ruhi Hira */
            WFWebServiceUtil.init(propMap, parser.toString());
        }
        
        if(basicAuthUser!=null &&!basicAuthUser.equalsIgnoreCase("")){
    		final String user=basicAuthUser;
    		final String pa_ss_word=basicAuth_P_wd;
    		Authenticator.setDefault(new Authenticator(){
    			protected PasswordAuthentication getPasswordAuthentication(){
    				return new PasswordAuthentication(user,pa_ss_word.toCharArray());
    			}
    		});
    	}
        
        
        Definition  definition=reader.readWSDL(null,WSDLPath);
        
        MultiValueMap typeList=new MultiValueMap();
		HashMap elementType=new LinkedHashMap();
		HashMap operationList=new LinkedHashMap();
		
		populateType(definition,typeList,elementType);
		String serviceName=convertWSDL(definition,operationList,typeList,elementType,parser);
		String wsdlOutput=simplifyWSDL(serviceName,operationList,parser,typeList,elementType);
		return wsdlOutput;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : convertWSDL
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : String serviceName, HashMap operations, XMLParser parser, MultiValueMap typeList,
			HashMap elementType
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : This method simplify xml of WSDL which contain all operation and their input and output variable and all complex type data present in wsdl
     * *******************************************************************************
     */
    private String simplifyWSDL(String serviceName, HashMap operations, XMLParser parser, MultiValueMap typeList,
			HashMap elementType) {
    	StringBuffer simplified = new StringBuffer();
        simplified.append("<WSDL>");
        simplified.append("<Services>");
        simplified.append("<ServiceInfo>");
        simplified.append("<ServiceName>");
        simplified.append(serviceName);
        simplified.append("</ServiceName>");
        simplified.append("</ServiceInfo>");
        simplified.append("</Services>");
        simplified.append("<Operations>");
        for (Iterator operationIterator = operations.entrySet().iterator(); operationIterator.hasNext(); ) {
            Map.Entry operationInfo = (Entry) operationIterator.next();			
            simplified.append("<OperationInfo>");
            simplified.append("<OperationName>");
            simplified.append(operationInfo.getKey());
            simplified.append("</OperationName>");
            simplified.append("<Parameters>");
            HashMap  parameters=(HashMap) operationInfo.getValue();	
			/* check added for WSDL operation with blank parameter by Anwar Ali Danish*/
			if(parameters != null){ 
				int j=1;
				for (Iterator paramIterator = parameters.entrySet().iterator(); paramIterator.hasNext(); ) {
					Map.Entry parameterInfo = (Entry)paramIterator.next();
					String key=(String) parameterInfo.getKey();
					Vector value=(Vector) parameterInfo.getValue();
					
					String scope="I";
					if("OUTPUT".equalsIgnoreCase(key)){
						scope="R";
					}
					for(int i=0;i<value.size();i++){
						Object obj=value.elementAt(i);
						if(obj instanceof HashMap){
							HashMap parameter=(HashMap) obj;
							for (Iterator it = parameter.entrySet().iterator(); it.hasNext(); ) {
								Map.Entry parameterDetail = (Entry)it.next();
								Parameter parameterObj=(Parameter) parameterDetail.getValue();
								if(parameterObj.isRef()){
									parameterObj=(Parameter) elementType.get(parameterObj.getName());
								}
								simplified.append("<Parameter>");
								simplified.append("<Index>");
								simplified.append(Integer.toString(j));
								simplified.append("</Index>");
								simplified.append("<Name>");
								simplified.append(parameterObj.getName());
								simplified.append("</Name>");
								dump(parser,parameterObj);
								String typeName="";
								String unbounded="N";
								if (parameterObj.getType()==WFSConstant.WF_COMPLEX){
									typeName = parameterObj.getTypeName();
								}
								simplified.append("<Type>");
								simplified.append(parameterObj.getType());
								simplified.append("</Type>");
								simplified.append("<TypeName>");
								simplified.append(typeName);
								simplified.append("</TypeName>");
								simplified.append("<Scope>");
								simplified.append(scope);
								simplified.append("</Scope>");
								if (parameterObj.isArray()) {
									unbounded = "Y";
								} else {
									unbounded = "N";
								}
								simplified.append("<Unbounded>");
								simplified.append(unbounded);
								simplified.append("</Unbounded>");
								simplified.append("</Parameter>");
								j++;
							}
						}else if(obj instanceof Parameter){
							Parameter parameterObj=(Parameter) obj;
							if(parameterObj.isRef()){
								parameterObj=(Parameter) elementType.get(parameterObj.getName());
							}
							simplified.append("<Parameter>");
							simplified.append("<Index>");
							simplified.append(Integer.toString(j));
							simplified.append("</Index>");
							simplified.append("<Name>");
							simplified.append(parameterObj.getName());
							simplified.append("</Name>");
							dump(parser,parameterObj);
							String typeName="";
							String unbounded="N";
							if (parameterObj.getType()==WFSConstant.WF_COMPLEX){
								typeName = parameterObj.getTypeName();
							}
							simplified.append("<Type>");
							simplified.append(parameterObj.getType());
							simplified.append("</Type>");
							simplified.append("<TypeName>");
							simplified.append(typeName);
							simplified.append("</TypeName>");
							simplified.append("<Scope>");
							simplified.append(scope);
							simplified.append("</Scope>");
							if (parameterObj.isArray()) {
								unbounded = "Y";
							} else {
								unbounded = "N";
							}
							simplified.append("<Unbounded>");
							simplified.append(unbounded);
							simplified.append("</Unbounded>");
							simplified.append("</Parameter>");
							j++;
						}else if(obj instanceof MultiValueMap){
							MultiValueMap parameter=(MultiValueMap) obj;
							for (Iterator it = parameter.entrySet().iterator(); it.hasNext(); ) {
								Map.Entry parameterDetail = (Entry)it.next();
								ArrayList parameterList=(ArrayList) parameterDetail.getValue();
								for(int  k=0;k<parameterList.size();k++){
									Object paramObj=parameterList.get(k);
									if(paramObj instanceof Parameter){
										Parameter parameterObj=(Parameter) paramObj;
										if(parameterObj.isRef()){
											parameterObj=(Parameter) elementType.get(parameterObj.getName());
										}
										simplified.append("<Parameter>");
										simplified.append("<Index>");
										simplified.append(Integer.toString(j));
										simplified.append("</Index>");
										simplified.append("<Name>");
										simplified.append(parameterObj.getName());
										simplified.append("</Name>");
										dump(parser,parameterObj);
										String typeName="";
										String unbounded="N";
										if (parameterObj.getType()==WFSConstant.WF_COMPLEX){
											typeName = parameterObj.getTypeName();
										}
										simplified.append("<Type>");
										simplified.append(parameterObj.getType());
										simplified.append("</Type>");
										simplified.append("<TypeName>");
										simplified.append(typeName);
										simplified.append("</TypeName>");
										simplified.append("<Scope>");
										simplified.append(scope);
										simplified.append("</Scope>");
										if (parameterObj.isArray()) {
											unbounded = "Y";
										} else {
											unbounded = "N";
										}
										simplified.append("<Unbounded>");
										simplified.append(unbounded);
										simplified.append("</Unbounded>");
										simplified.append("</Parameter>");
										j++;
									}
								}
							}
						}
					}
					
					
					
				}
			}
            simplified.append("</Parameters>");
            simplified.append("</OperationInfo>");
        }
        simplified.append("</Operations>");
        simplified.append("<Types>");
        
        Iterator typeIterator=typeList.entrySet().iterator();
		while(typeIterator.hasNext()) {
			Map.Entry typeEntry=(Entry) typeIterator.next();
			String typeName=(String) typeEntry.getKey();
			ArrayList typeValue=(ArrayList) typeEntry.getValue();
			simplified.append("<").append(typeName).append(">");
			simplified.append("<Attributes>");
			for(int i=0;i<typeValue.size();i++) {
				Object obj=typeValue.get(i);
				if(obj instanceof MultiValueMap) {
					String typeOutput=simplifyType((MultiValueMap) obj,elementType,typeList);
					simplified.append(typeOutput);
				}else if(obj instanceof Parameter) {
					Parameter parameter=(Parameter) obj;
					if(parameter.getType()==1000){
						String extendedMember=extendedMembers(parameter.getName(),typeList,elementType);
						simplified.append(extendedMember);
					}else{
					if(parameter.isRef()){
						parameter=(Parameter) elementType.get(parameter.getName());
					}
					String name=parameter.getName();
					Integer type=parameter.getType();
					String complexTypeName=parameter.getTypeName();
					Boolean isArray=parameter.isArray();
					String unbounded="N";
					if(type!=11) {
						complexTypeName="";
					}
					if(isArray) {
						unbounded="Y";
					}
					simplified.append("<Attribute>").append("<Name>").append(name).append("</Name>").append("<Type>").append(type).append("</Type>");
					simplified.append("<TypeName>").append(complexTypeName).append("</TypeName>").append("<Unbounded>").append(unbounded).append("</Unbounded>");
					simplified.append("</Attribute>");
					}
				}
			}
			simplified.append("</Attributes>");
			simplified.append("</").append(typeName).append(">");
		}
        simplified.append("</Types>");       
        simplified.append("</WSDL>");
        return simplified.toString();
	}
    
    private static String extendedMembers(String complexName, MultiValueMap typeList,HashMap elementType) {
    	StringBuilder output=new StringBuilder();
    	
    	Object obj=typeList.get(complexName);
    	if(obj instanceof Parameter){

			Parameter parameter=(Parameter) obj;
			if(parameter.getType()==1000){
				String extendedMember=extendedMembers(parameter.getName(),typeList,elementType);
				output.append(extendedMember);
			}else{
			if(parameter.isRef()){
				parameter=(Parameter) elementType.get(parameter.getName());
			}
			String name=parameter.getName();
			Integer type=parameter.getType();
			String complexTypeName=parameter.getTypeName();
			Boolean isArray=parameter.isArray();
			String unbounded="N";
			if(type!=11) {
				complexTypeName="";
			}
			if(isArray) {
				unbounded="Y";
			}
			output.append("<Attribute>").append("<Name>").append(name).append("</Name>").append("<Type>").append(type).append("</Type>");
			output.append("<TypeName>").append(complexTypeName).append("</TypeName>").append("<Unbounded>").append(unbounded).append("</Unbounded>");
			output.append("</Attribute>");
			}
		
    	}else if(obj instanceof MultiValueMap){
    		String typeOutput=simplifyType((MultiValueMap) obj,elementType,typeList);
    		output.append(typeOutput);
    	}else if(obj instanceof List){
    		List list=(List) obj;
    		for(int i=0;i<list.size();i++){
    			Object child=list.get(i);
    			if(child instanceof Parameter){

    				Parameter parameter=(Parameter) child;
    				if(parameter.getType()==1000){
    					String extendedMember=extendedMembers(parameter.getName(),typeList,elementType);
    					output.append(extendedMember);
    				}else{
    				if(parameter.isRef()){
    					parameter=(Parameter) elementType.get(parameter.getName());
    				}
    				String name=parameter.getName();
    				Integer type=parameter.getType();
    				String complexTypeName=parameter.getTypeName();
    				Boolean isArray=parameter.isArray();
    				String unbounded="N";
    				if(type!=11) {
    					complexTypeName="";
    				}
    				if(isArray) {
    					unbounded="Y";
    				}
    				output.append("<Attribute>").append("<Name>").append(name).append("</Name>").append("<Type>").append(type).append("</Type>");
    				output.append("<TypeName>").append(complexTypeName).append("</TypeName>").append("<Unbounded>").append(unbounded).append("</Unbounded>");
    				output.append("</Attribute>");
    				}
    			
    	    	}else if(child instanceof MultiValueMap){
    	    		String typeOutput=simplifyType((MultiValueMap) child,elementType,typeList);
    	    		output.append(typeOutput);
    	    	}    		}
    	}
    	
    	return output.toString();
	}

	private static String simplifyType(MultiValueMap typeList,HashMap elementType,MultiValueMap parentTypeList) {
		// TODO Auto-generated method stub
		StringBuffer childTypeSimplify=new StringBuffer();
		Iterator typeIterator=typeList.entrySet().iterator();
		while(typeIterator.hasNext()) {
			Map.Entry typeEntry=(Entry) typeIterator.next();
			String typeName=(String) typeEntry.getKey();
			ArrayList typeValue=(ArrayList) typeEntry.getValue();
			for(int i=0;i<typeValue.size();i++) {
				Object obj=typeValue.get(i);
				if(obj instanceof MultiValueMap) {
					String typeOutput=simplifyType((MultiValueMap) obj,elementType,parentTypeList);
					int index=childTypeSimplify.indexOf("</Attribute>");
					if(index>=0) {
						childTypeSimplify.delete(index,childTypeSimplify.length());
					}
					childTypeSimplify.append("<ChildAttribute>").append(typeOutput).append("</ChildAttribute>");
					childTypeSimplify.append("</Attribute>");
				}else if(obj instanceof Parameter) {
					Parameter parameter=(Parameter) obj;
					if(parameter.getType()==1000){
						String extendedMember=extendedMembers(parameter.getName(),parentTypeList,elementType);
						childTypeSimplify.append(extendedMember);
					}else{
					if(parameter.isRef()){
						parameter=(Parameter) elementType.get(parameter.getName());
					}
					String name=parameter.getName();
					Integer type=parameter.getType();
					String complexTypeName=parameter.getTypeName();
					Boolean isArray=parameter.isArray();
					String unbounded="N";
					if(type!=11) {
						complexTypeName="";
					}
					if(isArray) {
						unbounded="Y";
					}
					childTypeSimplify.append("<Attribute>").append("<Name>").append(name).append("</Name>").append("<Type>").append(type).append("</Type>");
					childTypeSimplify.append("<TypeName>").append(complexTypeName).append("</TypeName>").append("<Unbounded>").append(unbounded).append("</Unbounded>");
					childTypeSimplify.append("</Attribute>");
					}
				}
			}
		}
		return childTypeSimplify.toString();
	}
    
    
    /**
     * *******************************************************************************
     *      Function Name       : populateType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Definition definition, HashMap operationList,MultiValueMap typeList,HashMap elementType,XMLParser parser
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method parse the wsdl and simplify the wsdl document and store their information MultiValueMap
     * *
     * @throws IOException ******************************************************************************
     */
    private  String convertWSDL(Definition definition, HashMap operationList,MultiValueMap typeList,HashMap elementType,XMLParser parser) throws IOException {
		// TODO Auto-generated method stub
		String serviceName=null;
		Map serviceMap=definition.getServices();
		if(serviceMap!=null) {
			Iterator serviceIterator=serviceMap.entrySet().iterator();
			if(serviceIterator.hasNext())
			{
			while(serviceIterator.hasNext()) {
				Map.Entry serviceEntry=(Entry) serviceIterator.next();
				QName qServiceName=(QName) serviceEntry.getKey();
				if(qServiceName!=null) {
					serviceName=qServiceName.getLocalPart();
				}
				Service service=(Service) serviceEntry.getValue();
				HashMap portList=(HashMap) service.getPorts();
				Iterator portIterator=portList.entrySet().iterator();
				if(portIterator.hasNext())
				{
					while(portIterator.hasNext()) {
						Map.Entry portEntry=(Entry) portIterator.next();
						String portName=(String) portEntry.getKey();
						Port port=(Port) portEntry.getValue();
						dump(parser,"PortName >> " + portName);
						Binding binding=port.getBinding();
						selectBindingEntry(binding,definition,operationList,typeList,elementType,parser);
					}
			    }
			 }
		  }
		}
		
		return serviceName;
	}
    
    
   /**
    * *******************************************************************************
    *      Function Name       : populateType
    *      Date Written        : 15/07/2019
    *      Author              : Ravi Ranajn Kumar
    *      Input Parameters    : Binding binding, Definition definition, HashMap operationList,MultiValueMap typeList,HashMap elementType,XMLParser parser
    *      Output Parameters   : NONE.
    *      Return Values       : void.
    *      Description         : This method populate the all operation and their input and output 
    * *
 * @throws IOException ******************************************************************************
    */
    private  void selectBindingEntry(Binding binding, Definition definition, HashMap operationList,MultiValueMap typeList,HashMap elementType,XMLParser parser) throws IOException {
		// TODO Auto-generated method stub
		
		if(binding!=null) {
			List bindingOperationList=binding.getBindingOperations();
			Iterator bindingOperationIterator=bindingOperationList.iterator();
			while(bindingOperationIterator.hasNext()) {
				BindingOperation bindingOperation=(BindingOperation) bindingOperationIterator.next();
				Operation operation=bindingOperation.getOperation();
				String operationName= operation.getName();
				HashMap parameterList=new LinkedHashMap();
				dump(parser,"OperationName >> " + operationName);
				populateInputOutput(operation,definition,parameterList,typeList,elementType,bindingOperation);
				operationList.put(operationName, parameterList);
			}
		}
		
	}
    
    /**
     * *******************************************************************************
     *      Function Name       : populateType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Binding binding, Definition definition, HashMap operationList,MultiValueMap typeList,HashMap elementType,XMLParser parser
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate the  input and output 
     * *
  * @throws IOException ******************************************************************************
     */
    public  void populateInputOutput(Operation operation, Definition definition, HashMap parameterList,MultiValueMap typeList,HashMap elementType,BindingOperation bindingOperation) throws IOException {
		// TODO Auto-generated method stub
		if(operation==null)
			return;
		List parameterOrderList=operation.getParameterOrdering();
		if ((parameterOrderList != null) && parameterOrderList.isEmpty()) {
		   parameterOrderList = null;
	    }
		Input inputMessage=operation.getInput();
		Output outputMessage=operation.getOutput();
		HashMap inputType;
		
		if (parameterOrderList != null) {
	      if (inputMessage != null) {
	              Message inputMsg = inputMessage.getMessage();
	               Map allInputs = inputMsg.getParts();
	               Collection orderedInputs =inputMsg.getOrderedParts(parameterOrderList);
	               if (allInputs.size() != orderedInputs.size()) {
	                   throw new IOException(operation.getName()+"some error occured");
	               }
	           }
	     }
		 
		 
		Vector input=new Vector();
		Vector output=new Vector();
		
		
		if(inputMessage!=null) {
			inputType=new LinkedHashMap();
			getInputHeadeBodyType(bindingOperation,inputType,0);
			populateParameter(input,inputMessage.getMessage(),definition,typeList,elementType,inputType);
		}
		if(outputMessage!=null) {
			inputType=new LinkedHashMap();
			getInputHeadeBodyType(bindingOperation,inputType,1);
			populateParameter(output,outputMessage.getMessage(),definition,typeList,elementType,inputType);
		}
		if(parameterOrderList!=null) {
			Vector input1=new Vector();
			Iterator it=parameterOrderList.iterator();
			while(it.hasNext()) {
				String paramName=(String) it.next();
				if(paramName!=null) {
					for(int i=0;i<input.size();i++) {
						Parameter parameter=(Parameter) input.get(i);
						String name=parameter.getName();
						if(paramName.equalsIgnoreCase(name)) {
							input1.add(parameter);
							input.remove(i);
							break;
						}
						
					}
				}
			}
			parameterList.put("INPUT", input1);
			parameterList.put("OUTPUT", output);
		}
		else {
			parameterList.put("INPUT", input);
			parameterList.put("OUTPUT", output);
		}
		
		
	}

    //type=0 populating input type and type=1 populating outputType
    public void getInputHeadeBodyType(BindingOperation bindingOperation, HashMap inputType,int type) {
		// TODO Auto-generated method stub
    	if(bindingOperation==null)
    		return;
    	List parameterList=new ArrayList();
    	switch(type){
    	case 0:
    		BindingInput bindInput=bindingOperation.getBindingInput();
    		parameterList=bindInput.getExtensibilityElements();
    		break;
    	case 1:
    		BindingOutput bindOutput=bindingOperation.getBindingOutput();
    		parameterList=bindOutput.getExtensibilityElements();
    		break;
    	default:
    		return;
    	}
    	Iterator it=parameterList.iterator();
    	while(it.hasNext()){
    		Object obj=it.next();
    		if(obj!=null){
    			if( obj instanceof SOAPBodyImpl){
    				SOAPBodyImpl soapbody=(SOAPBodyImpl)obj;
    				List partList=soapbody.getParts();
    				if(partList!=null){
    				for(int i=0;i<partList.size();i++){
    					String name=(String) partList.get(i);
    					inputType.put(name, "I");
    				}}
    				
    			}else if(obj instanceof SOAPHeaderImpl){
    				SOAPHeaderImpl soapHeader=(SOAPHeaderImpl) obj;
    				String partName=soapHeader.getPart();
    				inputType.put(partName, "H");
    			}
    			
    		}
    	}
		
	}

	/**
     * *******************************************************************************
     *      Function Name       : populateType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : definition ,typeList,elementType- Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate the type present in wsdl in typeList and element type in elementtype
     * *******************************************************************************
     */
    private  void populateParameter(Vector vector, Message message,Definition definition,MultiValueMap typeList,HashMap elementType,HashMap inputType) {
		// TODO Auto-generated method stub
		if(message!=null) {
			HashMap partMap=(HashMap) message.getParts();
			Iterator partIterator=partMap.entrySet().iterator();
			while(partIterator.hasNext()) {
				Map.Entry partEntry=(Entry) partIterator.next();
				String partName=(String) partEntry.getKey();
				Part part=(Part) partEntry.getValue();
				QName elementName=part.getElementName();
				QName type=part.getTypeName();
				String localName=null;
				if(elementName!=null) {
					localName=elementName.getLocalPart();
				}
				Integer ibpsType=WFSConstant.WF_COMPLEX;
				if(type!=null) {
					ibpsType=getIBPSType(type.getLocalPart());
				}
				if(type!=null) {
					String typeLocalName=type.getLocalPart();
						if(ibpsType!=WFSConstant.WF_COMPLEX) {
							Parameter parameter=new Parameter(partName,ibpsType,type.getLocalPart(),false,0,false);
							if(inputType!=null && parameter!=null){
								String isHeader=(String) inputType.get(partName);
								parameter.setInputType(isHeader);
							}
							vector.add(parameter);
						}else {
							if(typeList.containsKey(typeLocalName)) {
								Parameter parameter=new Parameter(partName,ibpsType,type.getLocalPart(),false,0,false);
								if(inputType!=null && parameter!=null){
									String isHeader=(String) inputType.get(partName);
									parameter.setInputType(isHeader);
								}
								vector.add(parameter);
							}/*else{
								//type definition is not present in multivaluelist
							}*/
						}
				}
				else if(elementName!=null) {
					if(elementType.containsKey(localName)) {
						Parameter parameter=(Parameter) elementType.get(localName);
						String isHeader="I";
						if(inputType!=null && parameter!=null){
							isHeader=(String) inputType.get(partName);
							parameter.setInputType(isHeader);
						}
						if(parameter!=null&&parameter.getType()==WFSConstant.WF_COMPLEX && !"H".equalsIgnoreCase(isHeader)){
							ArrayList obj=(ArrayList) typeList.get(parameter.getTypeName());
							if(obj!=null){
								for(int i=0;i<obj.size();i++){
									Object param=obj.get(i);
									vector.add(param);
								}
							}
						}else{
							vector.add(parameter);
						}
					}
				}
			}
		}
		
		
		
	}
    
    /**
     * *******************************************************************************
     *      Function Name       : populateType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : definition ,typeList,elementType- Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate the type present in wsdl in typeList and element type in elementtype
     * *******************************************************************************
     */
    public  void populateType(Definition definition, MultiValueMap typeList, HashMap elementType) {
		// TODO Auto-generated method stub2
		Types type=definition.getTypes();
		List schemaList=type.getExtensibilityElements();
		Iterator it=schemaList.iterator();
		if(it.hasNext()) {
		while(it.hasNext()) {
			Schema schema= (Schema) it.next();
//			Element element=schema.getElement();
//			String localNameSpace=element.getNamespaceURI();
//			addType(element,typeList,elementType,localNameSpace);
			
			populateSchema(definition,schema,typeList,elementType);
		}
		}
	}
    public void populateSchema(Definition definition,Schema schema, MultiValueMap typeList, HashMap elementType){
    	if(schema!=null){
    		Element element=schema.getElement();
			String localNameSpace=element.getNamespaceURI();
			addType(element,typeList,elementType,localNameSpace);
			
			//Importing schema from other location
			Map map=schema.getImports();
			if(map!=null && map.size()>0){
				Iterator it=map.entrySet().iterator();
				if(it.hasNext())
				{
					while(it.hasNext()){
						Map.Entry entry=(Entry) it.next();
						List vector= (List) entry.getValue();
						if(vector!=null && vector.size()>0){
							for(Object obj:vector){
								if(obj!=null){
									if(obj instanceof SchemaImport || obj instanceof SchemaImportImpl){
										SchemaImport schemaImport=(SchemaImport) obj;
										Schema importSchema=schemaImport.getReferencedSchema();
										populateSchema(definition,importSchema,typeList,elementType);
									}
								}
							}
						}
					}
			   }
			}
    	}
    }
    

    /**
     * *******************************************************************************
     *      Function Name       : addType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Node ,typeList,elementType- Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate the type present in wsdl in typeList and element type in elementtype
     * *******************************************************************************
     */
    private  void addType(Node element, MultiValueMap typeList, HashMap elementType,String localNameSpace) {
		// TODO Auto-generated method stub
		String localName=element.getLocalName();
		String childNameSpaceURI=localNameSpace;
		boolean proceedToChild=true;
		if(localName!=null) {
			if("complexType".equalsIgnoreCase(localName)) {
				String name=getAttributeName(element,"name");
				if(name!=null&&name.length()>0) {
					MultiValueMap childType=getAllMemberVariable(element,childNameSpaceURI);
					if(childType!=null && childType.size()>0) {
						typeList.put(name, childType);
						proceedToChild=false;
					}
					Parameter param=getExtendedclass(element, childNameSpaceURI);
					if(param!=null){
						
						typeList.put(name, param);
					}
				}
				
			}else if("element".equalsIgnoreCase(localName)) {
				MultiValueMap childType=getAllMemberVariable(element,childNameSpaceURI);
				String name=getAttributeName(element,"name");
				String type=getAttributeName(element,"type");
				if(type==null) {
					type=name;
				}else {
					int index=type.indexOf(":");
					if(index>=0) {
						type=type.substring(index+1);
					}
				}
				if(name!=null&&name.length()>0) {
					MultiValueMap elementChildType=getAllMemberVariable(element,childNameSpaceURI);
					if(elementChildType!=null && elementChildType.size()>0) {
						typeList.put(type, elementChildType);
						proceedToChild=false;
					}
					Parameter parameter=getParameterObj(element,childNameSpaceURI);
					elementType.put(name, parameter);
				}
				
			}
			
		}
		if(localName!=null && "schema".equalsIgnoreCase(localName)){
			 String tempChildNameSpace=getAttributeName(element,"targetNamespace");
			 if(tempChildNameSpace!=null && !tempChildNameSpace.equalsIgnoreCase("")){
				 childNameSpaceURI=tempChildNameSpace;
			 }
		}
		if(proceedToChild) {
			NodeList nList=element.getChildNodes();
			if(nList!=null) {
			for(int i=0;i<nList.getLength();i++) {
				Node node=nList.item(i);
				addType(node,typeList,elementType,childNameSpaceURI);
			}}
		}
		
	}
    
    /**
     * *******************************************************************************
     *      Function Name       : addType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Node - Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate all meber variable
     * *******************************************************************************
     */
    private  MultiValueMap getAllMemberVariable(Node element,String childNameSpaceURI) {
		// TODO Auto-generated method stub
		MultiValueMap typeList=new MultiValueMap();
		NodeList nList=element.getChildNodes();
		if(nList.getLength()>0)
			{
				for(int i=0;i<nList.getLength();i++) {
					Node node=nList.item(i);
					String localName=node.getLocalName();
					if(localName!=null) {
						if("element".equalsIgnoreCase(localName)) {
							String name=getAttributeName(node,"name");
							String type=getAttributeName(node,"type");
							Parameter parameter=getParameterObj(node,childNameSpaceURI);
							if(name==null&&type==null){
								String ref=getAttributeName(node, "ref");
								int index=0;
								if(ref!=null){
									index=ref.indexOf(":");
								}
								if(index>0 && ref!=null)
									ref=ref.substring(index+1);
								name=ref;
								parameter.setRef(true);
								type=name;
							}
							if(parameter!=null) {
								typeList.put(name, parameter);
							}
							if(type==null) {
								MultiValueMap childtypeList=getAllMemberVariable(node,childNameSpaceURI);
								typeList.put(name, childtypeList);
							}
							
						}else {
							return getAllMemberVariable(node,childNameSpaceURI);
						}
					}
				}
			}
		
		return typeList;
	}
    
    private  Parameter getExtendedclass(Node element,String childNameSpaceURI) {
    	NodeList nList=element.getChildNodes();
    	Parameter param=null;
    	if(nList.getLength()>0)
    	{
			for(int i=0;i<nList.getLength();i++) {
				Node node=nList.item(i);
				String localName=node.getLocalName();
				if(localName!=null) {
					if("complexContent".equalsIgnoreCase(localName)) {
						param= getExtendedClassName(node);
						return param;
					}
				}
			}
        }
		return param;
    }
    private Parameter getExtendedClassName(Node element){
    	NodeList nList=element.getChildNodes();
    	Parameter param=null;
		for(int i=0;i<nList.getLength();i++) {
			Node node=nList.item(i);
			String localName=node.getLocalName();
			if(localName!=null) {
				if("extension".equalsIgnoreCase(localName)) {
					String className=getAttributeName(node,"base");
					if(className!=null){
						int index=className.indexOf(":");
						if(index>0){
							className=className.substring(index+1);
						}
					}
					param=new Parameter(className, 1000, className, false);
					return param;
				}
			}
		}
		return param;
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : addType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Node - Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method populate all meber variable
     * *******************************************************************************
     */
    private  Parameter getParameterObj(Node node,String nameSpace) {
		if(node==null)
			return null;
		String name=getAttributeName(node,"name");
		String type=getAttributeName(node,"type");
		String maxOccurs=getAttributeName(node,"maxOccurs");
		String minOccurs=getAttributeName(node,"minOccurs");
		String nillable=getAttributeName(node,"nillable");
		boolean isTypePresent=false;
		//String nameSpaceUri=node.getNamespaceURI();
		boolean isArray=false;
		boolean required=true;
		Integer min=0;
		try {
			min=Integer.parseInt(minOccurs);
		}catch(Exception e) {
			min=0;
			//Ignorable
		}
		if("unbounded".equalsIgnoreCase(maxOccurs)) {
			isArray=true;
		}
		if("true".equalsIgnoreCase(nillable)) {
			required=true;
		}
		if(type!=null) {
			int index=type.indexOf(":");
			if(index>0)
				type=type.substring(index+1);
			isTypePresent=true;
			
		}else if(name!=null) {
			type=name;
		}else{
			String ref=getAttributeName(node, "ref");
			int index=0;
			if(ref!=null){
				index=ref.indexOf(":");
			}
			if(index>0 && ref!=null)
				ref=ref.substring(index+1);
			type=ref;
			name=ref;
		}
		Integer iBPSType=getIBPSType(type);
		Parameter parameter=new Parameter(name,iBPSType,type,isArray,min,required);
		parameter.setNameSpaceURL(nameSpace);
		parameter.setTypePresent(isTypePresent);
		return parameter;
	}
    
    /**
     * *******************************************************************************
     *      Function Name       : addType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Node ,name- Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method return attribute value
     * *******************************************************************************
     */
    private static String getAttributeName(Node node, String name) {
		// TODO Auto-generated method stub
		String value=null;
		if(node!=null) {
			NamedNodeMap attr=node.getAttributes();
			if(attr!=null) {
				Node nodeattr=attr.getNamedItem(name);
				if(nodeattr!=null) {
					value=nodeattr.getTextContent();
				}
			}
			
		}
		return value;
	}

    /**
     * *******************************************************************************
     *      Function Name       : addType
     *      Date Written        : 15/07/2019
     *      Author              : Ravi Ranajn Kumar
     *      Input Parameters    : Node ,name- Inputs from the client.
     *      Output Parameters   : NONE.
     *      Return Values       : void.
     *      Description         : This method return attribute value
     * *******************************************************************************
     */
    private  Integer getIBPSType(String xmlType) {
        Integer javaType = WFSConstant.WF_COMPLEX;
        if(xmlType!=null){
	        if (xmlType.equalsIgnoreCase("string")||xmlType.equalsIgnoreCase("normalizedString")
	        		||xmlType.equalsIgnoreCase("NMTOKEN")||xmlType.equalsIgnoreCase("NMTOKENS")||
	        		xmlType.equalsIgnoreCase("token")) {
	            javaType = WFSConstant.WF_STR;
	        }else if(xmlType.equalsIgnoreCase("int")  || xmlType.equalsIgnoreCase("integer")||xmlType.equalsIgnoreCase("short")
	        		||xmlType.equalsIgnoreCase("unsignedInt")||xmlType.equalsIgnoreCase("unsignedShort")
	        		||xmlType.equalsIgnoreCase("positiveInteger")||xmlType.equalsIgnoreCase("negativeInteger")
	        		||xmlType.equalsIgnoreCase("nonPositiveInteger")||xmlType.equalsIgnoreCase("nonNegativeInteger")){
	        	javaType = WFSConstant.WF_INT;
	        }else if(xmlType.equalsIgnoreCase("boolean")){
	        	javaType = WFSConstant.WF_BOOLEAN;
	        }else if(xmlType.equalsIgnoreCase("long")||xmlType.equalsIgnoreCase("unsignedLong")){
	        	javaType = WFSConstant.WF_LONG;
	        }else if(xmlType.equalsIgnoreCase("date") || xmlType.equalsIgnoreCase("dateTime")){
	        	javaType = WFSConstant.WF_DAT;
	        }else if(xmlType.equalsIgnoreCase("float")||xmlType.equalsIgnoreCase("double")
	        		||xmlType.equalsIgnoreCase("decimal")){
	        	javaType = WFSConstant.WF_FLT;
	        }else if(xmlType.equalsIgnoreCase("time")){
	        	javaType = WFSConstant.WF_TIME;
	        }else if(xmlType.equalsIgnoreCase("anyType")){
	        	javaType = WFSConstant.WF_ANY;
	        }else if(xmlType.equalsIgnoreCase("byte")||xmlType.equalsIgnoreCase("unsignedByte")
	        		||xmlType.equalsIgnoreCase("base64Binary")||xmlType.equalsIgnoreCase("hexBinary")){
	        	javaType = 14;
	        }
	        
	      //add all type of iBPS and soap
        }
       
        return javaType;
    }


    /**
     * *******************************************************************************
     *      Function Name       : convertWSDL
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. symbolTable - axis symbol table.
     *                            2. generateDS - is datastructure to be generated ?
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : It receives the symbolTable from its calling method & 
     *                            returns to it WSDL in simplified form.
     * *******************************************************************************
     */
//    private String convertWSDL(SymbolTable symbolTable, boolean generateDS, XMLParser parser) throws Exception {
//        Service service = selectService(symbolTable);
//        BindingEntry bEntry = null;
//        String serviceName = null;
//        String portName = null;
//        HashSet QNames = new HashSet();
//        HashMap operations = new HashMap();
//        Port port = null;
//        Binding binding = null;
//        HashMap map = null;
//        Map.Entry entry = null;
//        Map ports = null;
//        String engine = "";
//        engine = parser.getValueOf("EngineName");
//        if (service != null) {
//            serviceName = service.getQName().getLocalPart();
//            ports = service.getPorts();     // PortName -> PortInformation
//            for (Iterator portIterator = ports.entrySet().iterator(); portIterator.hasNext(); ) { 
//                entry = (Map.Entry)portIterator.next();
//                portName = (String)entry.getKey();
//                dump(parser,"PortName >> " + portName);
//                port = (Port)entry.getValue();
//                binding = port.getBinding();
//                bEntry = symbolTable.getBindingEntry(binding.getQName());
//                selectBindingEntry(bEntry, symbolTable, QNames, operations, parser);
//            }
//            map = parseWSDL(symbolTable, QNames, parser);
//            if (generateDS) {
//                javifyMap(map, parser);
//            }
//            return simplifyWSDL(map, serviceName, operations, parser);
//        } else {
//            WFSUtil.printOut(engine,"Check! Check! Service is NULL");
//            return null;
//        }
//    }

    /**
     * *******************************************************************************
     *      Function Name       : simplifyWSDL
     *      Date Written        : 19/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : 1. map - map of classNames -> classInfo.
     *                            2. serviceName - Name of the service.
     *                            3. operations - list of operations.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : It simplifies the WSDL & returns the simplified form.
     * *******************************************************************************
     */
    private String simplifyWSDL(HashMap map, String serviceName, HashMap operations, XMLParser parser) {
        StringBuffer simplified = new StringBuffer();
        WFClassInfo classInfo = null;
        WFMemberInfo memberInfo = null;
        WFOperationInfo operationInfo = null;
        WFParameterInfo parameterInfo = null;
        ArrayList parameters = null;
        ArrayList members = null;
        String unbounded = "";
        String superClass = "";
        String typeName = "";
        simplified.append(LINE_SEPARATOR);
        simplified.append("<WSDL>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t<Services>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t\t<ServiceInfo>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t\t\t<ServiceName>");
        simplified.append(serviceName);
        simplified.append("</ServiceName>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t\t</ServiceInfo>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t</Services>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t<Operations>");
        for (Iterator operationIterator = operations.values().iterator(); operationIterator.hasNext(); ) {
            operationInfo = (WFOperationInfo)operationIterator.next();			
            simplified.append(LINE_SEPARATOR);
            simplified.append("\t\t<OperationInfo>");
            simplified.append(LINE_SEPARATOR);
            simplified.append("\t\t\t<OperationName>");
            simplified.append(operationInfo.getOperationName());
            simplified.append("</OperationName>");
            simplified.append(LINE_SEPARATOR);
            simplified.append("\t\t\t<Parameters>");
            parameters = operationInfo.getParameters();		
			/* check added for WSDL operation with blank parameter by Anwar Ali Danish*/
			if(parameters != null){ 
				for (Iterator paramIterator = parameters.iterator(); paramIterator.hasNext(); ) {
					parameterInfo = (WFParameterInfo)paramIterator.next();
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t<Parameter>");
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<Index>");
					simplified.append(parameterInfo.getIndex());
					simplified.append("</Index>");
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<Name>");
					simplified.append(parameterInfo.getName());
					simplified.append("</Name>");
					dump(parser,parameterInfo);
					if (parameterInfo.isComplexType()) {
						typeName = parameterInfo.getTypeName();
						classInfo = (WFClassInfo)map.get(typeName);
						if (classInfo.isAlias()) {
							memberInfo = (WFMemberInfo)(classInfo.getMembers().get(0));
							dump(parser,memberInfo);
							parameterInfo.setTypeId(memberInfo.fieldTypeId);
							parameterInfo.setArray(memberInfo.unbounded);
							parameterInfo.setTypeName(memberInfo.getType());
							if (parameterInfo.isComplexType()) {
								typeName = parameterInfo.getTypeName();
							} else {
								typeName = "";
							}
						}
					} else {
						typeName = "";
					}
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<Type>");
					simplified.append(parameterInfo.getTypeId());
					simplified.append("</Type>");
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<TypeName>");
					simplified.append(typeName);
					simplified.append("</TypeName>");
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<Scope>");
					simplified.append(parameterInfo.getScope());
					simplified.append("</Scope>");
					if (parameterInfo.isArray()) {
						unbounded = "Y";
					} else {
						unbounded = "N";
					}
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t\t<Unbounded>");
					simplified.append(unbounded);
					simplified.append("</Unbounded>");
					simplified.append(LINE_SEPARATOR);
					simplified.append("\t\t\t\t</Parameter>");
				}
			}
            simplified.append(LINE_SEPARATOR);
            simplified.append("\t\t\t</Parameters>");
            simplified.append(LINE_SEPARATOR);
            simplified.append("\t\t</OperationInfo>");
        }
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t</Operations>");
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t<Types>");
        for (Iterator mapIterator = map.values().iterator(); mapIterator.hasNext(); ) {
            classInfo = (WFClassInfo)mapIterator.next();
            if (!classInfo.isAlias()) {
                simplified.append(LINE_SEPARATOR);
                simplified.append("\t\t<" + classInfo.getClassName() + ">");
                superClass = classInfo.getSuperClass();
                if (superClass == null) {
                    superClass = "";
                }
                simplified.append(LINE_SEPARATOR);
                simplified.append("\t\t\t<ParentType>");
                simplified.append(superClass);
                simplified.append("</ParentType>");
                if (classInfo.getMemberCount() > 0) {
                    simplified.append(LINE_SEPARATOR);
                    simplified.append("\t\t\t<Attributes>");
                    members = classInfo.getMembers();
                    for (Iterator membersIterator = members.iterator(); membersIterator.hasNext(); ) {
                        memberInfo = (WFMemberInfo)membersIterator.next();
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t<Attribute>");
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t\t<Name>");
                        simplified.append(memberInfo.getName());
                        simplified.append("</Name>");
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t\t<Type>");
                        simplified.append(memberInfo.getfieldTypeId());
                        simplified.append("</Type>");
                        if (memberInfo.isComplexType()) {
                            typeName = memberInfo.getType();
                        } else {
                            typeName = "";
                        }
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t\t<TypeName>");
                        simplified.append(typeName);
                        simplified.append("</TypeName>");
                        if (memberInfo.isArray()) {
                            unbounded = "Y";
                        } else {
                            unbounded = "N";
                        }
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t\t<Unbounded>");
                        simplified.append(unbounded);
                        simplified.append("</Unbounded>");
                        simplified.append(LINE_SEPARATOR);
                        simplified.append("\t\t\t\t</Attribute>");
                    }
                    simplified.append(LINE_SEPARATOR);
                    simplified.append("\t\t\t</Attributes>");
                }
                simplified.append(LINE_SEPARATOR);
                simplified.append("\t\t</" + classInfo.className + ">");
            }
        }
        simplified.append(LINE_SEPARATOR);
        simplified.append("\t</Types>");
        simplified.append(LINE_SEPARATOR); 
        simplified.append("</WSDL>");
        return simplified.toString();
    }

    /**
     * *******************************************************************************
     *      Function Name       : createWFClassInfoObject
     *      Date Written        : 28/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : className      - Name of the java class.
     *                            superClassName - Name of the superclass (if any).
     *                            alias          - true -> java file to be generated, 
     *                                             false -> donot generate java file.
     *                            members        - Properties\ Members of the class.
     *      Output Parameters   : NONE.
     *      Return Values       : WFClassInfo object.
     *      Description         : Method to create WFClassInfo object.
     * *******************************************************************************
     */
    public WFClassInfo createWFClassInfoObject(String className, String superClassName, boolean alias, ArrayList members, String engineName) {
        WFClassInfo wfClassInfo = new WFClassInfo(className, superClassName, alias, members);
		dump(engineName,wfClassInfo);
        return wfClassInfo; 
    }

    /**
     * *******************************************************************************
     *      Function Name       : createWFMemberInfoObject
     *      Date Written        : 28/05/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : fieldName - Name of member\ Property.
     *                            fieldType - Datatype of member\ Property.
     *                            unbounded - true -> indicates array.
     *      Output Parameters   : NONE.
     *      Return Values       : WFMemberInfo object.
     *      Description         : Method to create WFMemberInfo object.
     * *******************************************************************************
     */
    public WFMemberInfo createWFMemberInfoObject(String fieldName, String fieldType, boolean unbounded, String engineName) {
        WFMemberInfo wfMemberInfo = new WFMemberInfo(fieldName, fieldType, unbounded);
		dump(engineName,wfMemberInfo);
        return wfMemberInfo;
    }

/**
     * *******************************************************************************
     *      Function Name       : serializeWFBDO
     *      Date Written        : 02/06/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : clazz - The Class. 
     *                            obj - The instance of clazz.
     *                            More precisely the object to be serialized.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Method to serializes WF Business Data Object.
     *                            Generates Input XML for setAtrributes.
     *                            To be used for WI initiation through Webservices.
     *                            Willnot generate tags for NULL values.
     * *******************************************************************************
     */
    public String serializeWFBDO(Class clazz, Object obj) throws Exception {
        return serializeWFBDO(clazz, obj, false);
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : serializeWFBDO
     *      Date Written        : 02/06/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : clazz - The Class.
     *                            obj - The instance of clazz. 
     *                            More precisely the object to be serialized.
     *                            WSFlag - true -> Use 'T', 'Z' for webservice date/ dateTime.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Method to serializes WF Business Data Object.
     *                            Generates Input XML for setAtrributes.
     *                            To be used for WI initiation through Webservices.
     *                            Willnot generate tags for NULL values.
     * *******************************************************************************
     */
    public String serializeWFBDO(Class clazz, Object obj, boolean WSFlag) throws Exception {
        XMLGenerator gen = new XMLGenerator();
        StringBuffer xml = new StringBuffer();
        String output = "";
        String propertyName = "";
        Class innerClazz = null;
        Class arrayClazz = null;
        Object objArray = null;
        Object value = null;
        /* All objects inherit from java.lang.Object, need to bypass all getters belonging to java.lang.Object. */
        BeanInfo beanInfo = Introspector.getBeanInfo(clazz, (new Object()).getClass());
        PropertyDescriptor[] propDescs = beanInfo.getPropertyDescriptors();
        boolean collection = false;
        int arrayLength = -1;
        for (int i = 0; i < propDescs.length; i++) {
            innerClazz = propDescs[i].getPropertyType();
            if (innerClazz.isArray()) {
                innerClazz = innerClazz.getComponentType();
                collection = true;
            } else {
                collection = false;
            }
            if (innerClazz.isPrimitive() || innerClazz == String.class || innerClazz == Integer.class || innerClazz == Float.class || innerClazz == Long.class || innerClazz == Boolean.class || innerClazz == java.util.Date.class || innerClazz == Calendar.class || innerClazz == Double.class) {
                if (collection) {
                    objArray = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                    if (objArray != null) {
                        arrayLength = Array.getLength(objArray);
                        propertyName = calculatePropertyName(clazz, propDescs[i].getName(), WSFlag);
                        for (int j = 0; j < arrayLength; j++) {
                            value = Array.get(objArray, j);
							output = setValue(value, WSFlag);
							if(output != null)
								xml.append(gen.writeValueOf(propertyName, WFSUtil.handleSpecialCharInXml(output)));
							else
								xml.append(gen.writeValueOf(propertyName, output));
                        }
                    }
                } else {
					propertyName = calculatePropertyName(clazz, propDescs[i].getName(), true);
                    value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                    output = setValue(value, WSFlag);
                    //propertyName = calculatePropertyName(clazz, propDescs[i].getName(), WSFlag);
                    if(output != null)
						xml.append(gen.writeValueOf(propertyName, WFSUtil.handleSpecialCharInXml(output)));
					else
						xml.append(gen.writeValueOf(propertyName, output));
                }
            } else {
                if (collection) {
                    objArray = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                    if (objArray != null) {
                        arrayLength = Array.getLength(objArray);
                        propertyName = calculatePropertyName(clazz, propDescs[i].getName(), WSFlag);
                        for (int k = 0; k < arrayLength; k++) {
                            output = "";
                            value = Array.get(objArray, k);
                            if (value != null) {
                                arrayClazz = value.getClass();
                                output = serializeWFBDO(arrayClazz, Array.get(objArray, k), WSFlag);
								xml.append(gen.writeValueOf(propertyName, output));
                            }
                        }
                    }
                } else {
                    value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                    if (value != null) {
                        output = serializeWFBDO(innerClazz, value, WSFlag);
                        propertyName = calculatePropertyName(clazz, propDescs[i].getName(), WSFlag);
                        xml.append(gen.writeValueOf(propertyName, output));
                    }
                }
            } 
        }
        return xml.toString();
    }
	/**
     * *******************************************************************************
     *      Function Name       : serializeWFBDOExt
     *      Date Written        : 02/06/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : clazz - The Class.
     *                            obj - object to be serialized
     *                            l - counter for accessing the arrayList containing searchable Attributes
     *                            ArrayList arr contains searchable Attributes(WFCorrelationTable)
                                  boolean setNull(true causes the searchable attributes to be null)
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Traverses ArrayList containg searchable Attributes and then returns xml for searchWorkitems
     * *******************************************************************************
     */
	public Object serializeWFBDOExt(Class clazz, Object obj,int l, ArrayList arr,  ArrayList searchTags, boolean setNull) throws Exception {
        XMLGenerator gen = new XMLGenerator();
        StringBuffer xml = new StringBuffer();
        String output = "";
        String propertyName = "";
        Class innerClazz = null;
        Class arrayClazz = null;
        Object objArray = null;
        Object value = null;
       /* All objects inherit from java.lang.Object, need to bypass all getters belonging to java.lang.Object. */
        BeanInfo beanInfo = Introspector.getBeanInfo(clazz, (new Object()).getClass());
        PropertyDescriptor[] propDescs = beanInfo.getPropertyDescriptors();
        boolean collection = false;
        int arrayLength = -1;
        
            for (int i = 0; i < propDescs.length; i++) {
                innerClazz = propDescs[i].getPropertyType();
                String name = propDescs[i].getName();
                if (name.equalsIgnoreCase((String) arr.get(l))) {
                    if (innerClazz.isArray()) {
                        innerClazz = innerClazz.getComponentType();
                        collection = true;
                    } else {
                        collection = false;
                    }
                    if (innerClazz.isPrimitive() || innerClazz == String.class || innerClazz == Integer.class || innerClazz == Float.class || innerClazz == Long.class || innerClazz == Boolean.class || innerClazz == java.util.Date.class || innerClazz == Calendar.class || innerClazz == Double.class) {
                        if (collection) {
                            if (setNull) {
                                propDescs[i].getWriteMethod().invoke(obj, new Object[] {null});
                               //WFSUtil.printOut(parser,"calling setter for bdo 1");
                            } else {
                                objArray = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                                if (objArray != null) {
                                    arrayLength = Array.getLength(objArray);
                                    propertyName = propDescs[i].getName();
                                    for (int j = 0; j < arrayLength; j++) {
                                        value = Array.get(objArray, j);
                                        output = setValue(value,false);
                                        //WFSUtil.printOut("PropertyName>> " + propertyName + "PropertyValue>> "+output);
                                        //xml.append(gen.writeValueOf(propertyName, output));
                                    }
                                }
                            }
                        } else {
                            if (setNull) {
                                propDescs[i].getWriteMethod().invoke(obj, new Object[] {null});
                                //WFSUtil.printOut("calling setter for bdo 2");
                            } else {
                                value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                                propertyName = propDescs[i].getName();
//                                WFSUtil.printOut("display name was >> "+propDescs[i].getDisplayName());
//                                WFSUtil.printOut("getter name was >> "+propDescs[i].getReadMethod().getName());
//                                WFSUtil.printOut("value of "+ propertyName + " was >> "+ value);
                                output = setValue(value,false);
                                //WFSUtil.printOut("PropertyName>> " + propertyName + "PropertyValue>> "+output);
                                //xml.append(gen.writeValueOf(propertyName, output));
                            }
                        }
                    } else {
                        if (collection) {
                            if (setNull) {
                               // WFSUtil.printOut("calling setter for bdo 4");
                                value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                                if (value != null) 
                                   serializeWFBDOExt(innerClazz, value, ++l,arr, searchTags, setNull);
                            } else {
                                objArray = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                                if (objArray != null) {
                                    arrayLength = Array.getLength(objArray);
                                    propertyName = propDescs[i].getName();
                                    for (int k = 0; k < arrayLength; k++) {
                                        output = "";
                                        value = Array.get(objArray, k);
                                        //WFSUtil.printOut("value of "+ propertyName + " was >> "+ value);
										if (value != null) {
                                            arrayClazz = value.getClass();
                                            output = (String) serializeWFBDOExt(arrayClazz, Array.get(objArray, k), ++l,arr,searchTags,setNull);
                                            //WFSUtil.printOut("PropertyName>> " + propertyName + "PropertyValue>> "+output);
                                            //xml.append(gen.writeValueOf(propertyName, output));
                                        }
                                    }
                                }
                            }
                        } else {
                            if (setNull) {
                                //propDescs[i].getWriteMethod().invoke(obj, new Object[] {null});
                                //WFSUtil.printOut("calling setter for bdo 4");
                                value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                                if (value != null)
                                    serializeWFBDOExt(innerClazz, value, ++l,arr, searchTags, setNull);
                            } else {
                                value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
                               // WFSUtil.printOut("value of "+ propertyName + " was >> "+ value);
								if (value != null) {
                                    output = (String) serializeWFBDOExt(innerClazz, value, ++l,arr, searchTags, setNull);
                                    propertyName = propDescs[i].getName();
                                  //  WFSUtil.printOut("PropertyName>> " + propertyName + "PropertyValue>> "+output);
                                    //xml.append(gen.writeValueOf(propertyName, output));
                                }
                            }
                        }
                    } 
                }
            }
        
        if (setNull) {
            return obj;
		}
        else {
            return output;
		}
    }
	/**
     * *******************************************************************************
     *      Function Name       : setResponseBDO
     *      Date Written        : 02/06/2008
     *      Author              : Shweta Tyagi
     *      Input Parameters    : clazz - The Class.
     *                            obj - object to be serialized
     *                            ArrayList arr (List Of Maps) from fetchAttributesExt 
                                  boolean setNull(true causes the searchable attributes to be null)
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : 
     * *******************************************************************************
     */
	public Object setResponseBDO(Class clazz, Object obj, ArrayList arr) throws Exception {
        Class innerClazz = null;
        Object input = null;
		Object value = null;
		Object valueFromMap = null;
        Object objArray = null;
        BeanInfo beanInfo = Introspector.getBeanInfo(clazz, (new Object()).getClass());
        PropertyDescriptor[] propDescs = beanInfo.getPropertyDescriptors();
        boolean collection = false;
		try {
            for (int i = 0; i < propDescs.length; i++) {
                innerClazz = propDescs[i].getPropertyType();
                String name = propDescs[i].getName();
               // WFSUtil.printOut("propertyName>> " + name);
				for (int j = 0; j < arr.size(); j++) {
					HashMap valMap = (HashMap) arr.get(j); 
					//WFSUtil.printOut("[ setResponseBDO ] hashMap in setResponseBDO"+valMap);
					if (valMap.containsKey(name.toUpperCase())) {
						valueFromMap = valMap.get(name.toUpperCase());
						if (innerClazz.isArray()) {
							innerClazz = innerClazz.getComponentType();
							collection = true;
						} else {
							collection = false;
						}
						if (innerClazz.isPrimitive() || innerClazz == String.class || innerClazz == Integer.class || innerClazz == Float.class || innerClazz == Long.class || innerClazz == Boolean.class || innerClazz == java.util.Date.class || innerClazz == Calendar.class || innerClazz == Double.class) {
							if (collection) {
								/*primitive array*/
							    ArrayList temp = (ArrayList) valueFromMap;
								ArrayList valueList = new ArrayList();
								ListIterator itr = temp.listIterator();
								while(itr.hasNext()) {
									input = (String) itr.next();
									input = WFWebServiceUtil.getValueForSimpleType(innerClazz.getName(),(String)input); 
									valueList.add(input);
								}
								value =  Array.newInstance(innerClazz, valueList.size());
								System.arraycopy(valueList.toArray(), 0, value, 0, valueList.size());
								propDescs[i].getWriteMethod().invoke(obj, new Object[] {value});
								//WFSUtil.printOut("[setResponseBDO] calling setter for bdo 1");
							} else {
								
								/*primitive values*/
								input = ((ArrayList) valueFromMap).get(0);
								//WFSUtil.printOut("[setResponseBDO] setting value as >> "+input);
								input = WFWebServiceUtil.getValueForSimpleType(innerClazz.getName(),(String)input); 
								//WFSUtil.printOut("[setResponseBDO] name of setter >> "+propDescs[i].getWriteMethod().getName());
								propDescs[i].getWriteMethod().invoke(obj, new Object[] {input});
								//WFSUtil.printOut("[setResponseBDO] calling setter for bdo 2");
							}
						} else {
							/*valueFromMap will be arraylist of maps  */
							if (collection) {
								/*complex array*/	
								//WFSUtil.printOut("[ setResponseBDO ] calling setter for bdo 3");
									objArray = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
									//WFSUtil.printOut(propDescs[i].getPropertyType().getName());
									value = propDescs[i].getPropertyType().newInstance();
									value = setResponseBDO(innerClazz, value, (ArrayList) valueFromMap);
									ArrayList valueList = new ArrayList();
									valueList.add(value);
									if (objArray==null) {
										//creating first element of complex array
										objArray =  Array.newInstance(innerClazz, valueList.size());
										System.arraycopy(valueList.toArray(), 0, objArray, 0, valueList.size());
										propDescs[i].getWriteMethod().invoke(obj, new Object[] {objArray});
									} else {
										//creating elements further and adding to the complex array from offset(j)
										System.arraycopy(valueList.toArray(), j, objArray, 0, valueList.size());
									}
									propDescs[i].getWriteMethod().invoke(obj, new Object[] {objArray});
							} else {
								/*complex*/	
								//WFSUtil.printOut("[ setResponseBDO ]calling setter for bdo 4");
									value = propDescs[i].getReadMethod().invoke(obj, new Object[] {});
									if (value==null) {
										//WFSUtil.printOut(propDescs[i].getPropertyType().getName());
										value = propDescs[i].getPropertyType().newInstance();
										value = setResponseBDO(innerClazz, value, (ArrayList) valueFromMap);
										propDescs[i].getWriteMethod().invoke(obj, new Object[] {value});
									}
							}	
						} 
					}
				}
				
            }
		} catch(Exception ex) {
			//WFSUtil.printErr(ex);
		}
      //  WFSUtil.printOut(serializeWFBDO(obj.getClass(),obj));
		return obj;
    }
    /**
     * *******************************************************************************
     *      Function Name       : setValue
     *      Date Written        : 27/06/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : value - the value which will be analyzed.
     *                            WSFlag - true -> Use 'T', 'Z' for webservice date/ dateTime.
     *      Output Parameters   : NONE.
     *      Return Values       : String.
     *      Description         : Method analyzes value in input and converts it into OF 
     *                            compatible format.
     * *******************************************************************************
     */
    public String setValue(Object value, boolean WSFlag) {
        String dateFormat = "yyyy-MM-dd HH:mm:ss"; /*Bug # 7546*/
        if (WSFlag) {
            /** 'T' separates date & time, 'Z' separates time and timezone. */
            dateFormat = "yyyy-MM-dd'T'H:mm:ss'Z'";
        }
        if (value != null) {
            if (value instanceof java.util.Date) {
                value = new java.text.SimpleDateFormat(dateFormat, Locale.US).format((java.util.Date) value);
            } else if (value instanceof Calendar) {
                value = new java.text.SimpleDateFormat(dateFormat, Locale.US).format(((Calendar) value).getTime());
            }
            return value.toString();
        } else {
            return null;
        }
    }
    
    /**
     * *******************************************************************************
     *      Function Name       : calculatePropertyName
     *      Date Written        : 08/10/2008
     *      Author              : Varun Bhansaly
     *      Input Parameters    : clazz - The class whose fields will be accessed.
     *                            propertyName - The properyName to be searched.
     *                            WSFlag - Donot break old clients who are not aware of the new 
     *                            functionalities. It will be false for them.
     *      Output Parameters   : NONE.
     *      Return Values       : String -> The propertyName.
     *      Description         : PropertyDescriptor.getPropertyName() follows JAVA Bean specs.
     *                            Many case-sensitive web services require tag names should in the case specified 
     *                            in the WSDL. For these we use the Field class which returns orginal case.
     * *******************************************************************************
     */
    private String calculatePropertyName(Class clazz, String propertyName, boolean WSFlag) throws Exception {
        if (WSFlag) {
            /** 
             * Will access public properties only, this is the reason why we create public methods in datastrcture jar. 
             * - Varun Bhansaly
             **/
            Field[] fields = clazz.getFields();
            String fieldName = "";
            for (int i = 0; i < fields.length; i++) {
                fieldName = fields[i].getName();
                if (fieldName.equalsIgnoreCase(propertyName)) {
                    propertyName = fieldName;
                    break;
                }
            }
        }
        return propertyName;
    }

	public static void main(String[] args) {
        HashMap map = null;
        String wsdl = null;
		String xml = null;
        WFWebServiceHelperUtil client = new WFWebServiceHelperUtil();
	    try {
           // Parser wsdlParser = new Parser();
          //  wsdlParser.run(args[1]);
            XMLParser parser = new XMLParser();
          //  wsdl = client.convertWSDL(wsdlParser.getSymbolTable(), true, parser); //only for testing
         //   parser = null;
            WFSUtil.printOut("",wsdl);
			
			
        } catch (Exception e) {
           // WFSUtil.printErr("Error!!!", e);
		} finally {
        }
    }
}
