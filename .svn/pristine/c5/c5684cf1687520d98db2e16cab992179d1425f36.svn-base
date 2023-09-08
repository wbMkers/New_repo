/***************************************************************************
 *	Product		: iBPS
 *	Application	: Server and Services
 *	Module		: 
 *	File		: JSONObject.java
 *
 *	Purpose:
 *     Contains various function to a List to JSONObject
 *
 *
 *   Change History:
 *	Problem No		Correction Date	 Changed By			Comments
	----------		---------------	---------		-------------------------------------------
 * //26/09/2019	Ambuj Tripathi		Bug 86955	IBPS 4.0 Internal Bug fixed during hotfix testing for Client Wespath 
 * //15/11/2019        Sourabh Tantuway Bug 88227 - iBPS 4.0 SP0 : Workitem history is not getting downloaded while clicking on save button. It is showing no history present even if API output is returning history.
 * //25/08/2020        Ravi Raj Mewara  Bug 94280 - iBPS 4.0 : In Saved Audit trail values of variable coming wrong
  ***************************************************************************/
package com.newgen.omni.jts.util.json;

import java.io.StringReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.newgen.omni.jts.util.WFSUtil;

public class JSONObject extends HashMap{
	
	public String toString(){
		ItemList list=new ItemList();
		Iterator iter=entrySet().iterator();
		
		while(iter.hasNext()){
			Map.Entry entry=(Map.Entry)iter.next();
			list.add(toString(entry.getKey().toString(),entry.getValue()));
		}
		return "{"+list.toString()+"}";
	}
	
	public static String toString(String key,Object value){
		StringBuffer sb=new StringBuffer();
		
		sb.append("\"");
		sb.append(escape(key));
		sb.append("\":");
		if(value==null){
			sb.append("null");
			return sb.toString();
		}
		
		if(value instanceof String){
			sb.append("\"");
			sb.append(escape((String)value));
			sb.append("\"");
		}
		else
			sb.append(value);
		return sb.toString();
	}
	/********************************************************************
   Function name      : getAttributeFields
   Description        : to get the Attribute Fields from Json Message.
   Return type        :
   Argument 1         :
   ********************************************************************/
  public static StringBuilder getAttributeFields(String strField1,String variableStr, String strWasSetTo, String strPrevValue,String strBy,String strUserAndPName) {
        StringBuilder strReturnBuffer = new StringBuilder("");
        if (strField1.equalsIgnoreCase("")) {
            strReturnBuffer.append("");
        } else {
            String strMessageJSON = strField1;
            JSONObject jsonObj = null;
            JSONObject messageObj = null;
            String value = "";
            String prevValue = "";
            try {
                jsonObj = (JSONObject) new JSONParser().parse(new StringReader(strMessageJSON));
            } catch (Exception e) {
            }
            if (jsonObj != null) {
                messageObj = (JSONObject) jsonObj.get("Message");
                JSONObject fieldNameObj = (JSONObject) messageObj.get("FieldName");
                JSONObject attributesObj = (JSONObject) fieldNameObj.get("Attributes");
                //JSONObject activityObj  = (JSONObject) messageObj.get("ActivityName");
              //  JSONObject prcInstanObj  = (JSONObject) messageObj.get("ProcessInstance");
                JSONObject objAttribute = null;
                strReturnBuffer.append("<Message>");
                strReturnBuffer.append("<ActivityName>"+messageObj.get("ActivityName").toString()+"</ActivityName>");
                strReturnBuffer.append("<ProcessInstanceID>"+messageObj.get("ProcessInstance").toString()+"</ProcessInstanceID>");
                
                strReturnBuffer.append("<Attributes>");
                if (attributesObj.get("Attribute") instanceof JSONObject) {
                    objAttribute = (JSONObject) attributesObj.get("Attribute");
                    if(objAttribute.get("Value")!=null){
                         value= objAttribute.get("Value").toString();
                         if(value.contains("&lt;")||value.contains("&gt;")){
                           value = handleSpecialCharacterInJson(value); 
                         }else{
                            value = objAttribute.get("Value").toString();
                         }
                    }
                    if(objAttribute.get("PreviousValue")!=null){
                    	prevValue= objAttribute.get("PreviousValue").toString();
                        if(prevValue.contains("&lt;")||prevValue.contains("&gt;")){
                        	prevValue = handleSpecialCharacterInJson(value); 
                        }else{
                        	prevValue = objAttribute.get("PreviousValue").toString();
                        }
                   }
                    strReturnBuffer.append("<Attribute>");
                    String attrStr = variableStr+" '" + objAttribute.get("Name").toString() + "' "+strWasSetTo+" '" + value + "' "+strPrevValue+" '" + prevValue + "' "+strBy+" "+strUserAndPName;
                    attrStr= WFSUtil.handleSpecialCharInXml(attrStr);
                    strReturnBuffer.append(attrStr);
                    strReturnBuffer.append("</Attribute>");
                } else {
                    JSONArray attributeList = (JSONArray) attributesObj.get("Attribute");
                    for (int iLoopIndex = 0; iLoopIndex < attributeList.size(); iLoopIndex++) {
                       objAttribute = (JSONObject) attributeList.get(iLoopIndex);
                        value="";
                        if(objAttribute.get("Value")!=null){
                           value= objAttribute.get("Value").toString();
                           if(value.contains("&lt;")||value.contains("&gt;")){
                             value = handleSpecialCharacterInJson(value); 
                           }else{
                              value = objAttribute.get("Value").toString();
                           }
                        }
                        if(objAttribute.get("PreviousValue")!=null){
                        	prevValue= objAttribute.get("PreviousValue").toString();
                            if(prevValue.contains("&lt;")||prevValue.contains("&gt;")){
                            	prevValue = handleSpecialCharacterInJson(value); 
                            }else{
                            	prevValue = objAttribute.get("PreviousValue").toString();
                            }
                       }
                       strReturnBuffer.append("<Attribute>");
                       String attrStr = variableStr+" '" + objAttribute.get("Name").toString() + "' "+strWasSetTo+" '" + value + "' "+strPrevValue+" '" + prevValue + "' "+strBy+" "+strUserAndPName;
                       attrStr= WFSUtil.handleSpecialCharInXml(attrStr);
                       strReturnBuffer.append(attrStr);
                       strReturnBuffer.append("</Attribute>");
                    }
                }
                strReturnBuffer.append("</Attributes>");
                strReturnBuffer.append("</Message>");
            }
        }
        return strReturnBuffer;
    }
	
    public static String handleSpecialCharacterInJson(String strXml){
        strXml = strXml.replace("&amp;", "&");
        strXml = strXml.replace( "&lt;", "<");
        strXml = strXml.replace( "&gt;", ">");
        strXml = strXml.replace( "&quot;", "\"");
        strXml = strXml.replace("&apos;", "'");

        return strXml;
    }
	public static String escape(String s){
		if(s==null)
			return null;
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<s.length();i++){
			char ch=s.charAt(i);
			switch(ch){
			case '"':
				sb.append("\\\"");
				break;
                        case '\'':
				sb.append("\\'");
				break;        
			case '\\':
				sb.append("\\\\");
				break;
			case '\b':
				sb.append("\\\b");
				break;
			case '\f':
				sb.append("\\\f");
				break;
			case '\n':
				sb.append("\\\n");
				break;
			case '\r':
				sb.append("\\\r");
				break;
			case '\t':
				sb.append("\\\t");
				break;
			case '/':
				sb.append("\\/");
				break;
			default:
				if(ch>='\u0000' && ch<='\u001F'){
					String ss=Integer.toHexString(ch);
					sb.append("\\u");
					for(int k=0;k<4-ss.length();k++){
						sb.append('0');
					}
					sb.append(ss.toUpperCase());
				}
				else{
					sb.append(ch);
				}
			}
		}//for
		return sb.toString();
	}
}

