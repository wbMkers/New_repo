//---------------------------------------------------------------------------------------------------- 
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group						: Application Products 
//	Product / Project			: Java Transaction Server
//	Module						: ODTS
//	File Name					: WFException.java	
//	Author						: Prashant
//	Date written (DD/MM/YYYY)	: 30/10/2002
//	Description					: Defines the Exception thrown by all WAPI calls.
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
//  Date					Change By		Change Description (Bug No. (If Any))
//  (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 05/04/2005				Ashish/ Ruhi	SrNo-1.
// 29/12/2008				Ashish Mangla	Bugzilla Bug 7519 (override method getErrorCode() of JTSException)
//07/12/2017				Ambuj Tripathi	Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml
//----------------------------------------------------------------------------------------------------


package com.newgen.omni.jts.excp;

public class WFSException extends JTSException {    
	private int mainErrorCode;
	private int subErrorCode;
	private String typeOfError;
	private String errorMessage;
	private String errorDescription;
    private String dataXML;
    
	public WFSException(int mainErrorCode, int subErrorCode, String typeOfError, 
						String errorMessage, String errorDescription){
    	this(mainErrorCode, subErrorCode, typeOfError, errorMessage, errorDescription, null);
    }
    public WFSException(int mainErrorCode, int subErrorCode, String typeOfError, 
			String errorMessage, String errorDescription, String dataXML){
		super(mainErrorCode);
		this.mainErrorCode = mainErrorCode;
		this.subErrorCode = subErrorCode;
		this.typeOfError = typeOfError;
		// SrNo-1, Extract exception description if found null.
		if (errorMessage == null ) {
			this.errorMessage = WFSErrorMsg.getMessage(mainErrorCode);;
		} else {
			this.errorMessage = errorMessage;
		}
		if ( errorDescription == null ) {
			this.errorDescription = WFSErrorMsg.getMessage(subErrorCode);;
		} else {
			this.errorDescription = errorDescription;
		}
		this.dataXML = dataXML;
    }

	public int getMainErrorCode() {
		return mainErrorCode ;
	}
	public int getSubErrorCode() {
		return subErrorCode; 
	}
	public String	getTypeOfError() {
		return typeOfError; 
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public String getErrorDescription() {
		return errorDescription;
	}

	public String getMessage() {
		StringBuffer strOutputBuffer = new StringBuffer();
		try{
		    strOutputBuffer.append("<Exception>");
			strOutputBuffer.append("\t<MainCode>"+String.valueOf(mainErrorCode)+"</MainCode>\n");
			if (subErrorCode != 0)
				strOutputBuffer.append("\t<SubErrorCode>"+String.valueOf(subErrorCode)+"</SubErrorCode>\n");
			strOutputBuffer.append("\t<TypeOfError>"+String.valueOf(typeOfError)+"</TypeOfError>\n");
			strOutputBuffer.append("\t<Subject>"+String.valueOf(errorMessage)+"</Subject>\n");
			if (subErrorCode != 0)
				strOutputBuffer.append("\t<Description>"+String.valueOf(errorDescription)+"</Description>\n");
		    strOutputBuffer.append("</Exception>");
		}
        catch (Exception e) {}
		return strOutputBuffer.toString();
	}//end-generalError (for WorkFlow Error)

	public int getErrorCode() {
		return getMainErrorCode();
	}
    public String getDataXML() {
		return dataXML;
	}
}//end-WFSException
