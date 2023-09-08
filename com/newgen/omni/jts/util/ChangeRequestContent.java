/* --------------------------------------------------------------------------
            //                       NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//                   Group                    : Application-Products
//                   Product / Project        : iBPS
//                   Module                   : Omniflow Server
//                   File Name                : ChangeRequestContent.java
//                   Author                   : Ravi Ranjan Kumar
//                   Date written (DD/MM/YYYY): 01/06/2020
//                   Description              : Modify the content of request before sending them
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date           Changed By          Change Description (Bug No. If Any)
 --------------------------------------------------------------------------*/

package com.newgen.omni.jts.util;


public class ChangeRequestContent {
	
	//public static void  main(String args[]) {
//		String input="<query><text>NMB</text><type>UNICODE</type></query>";
//		input=(XML.toJSONObject(input)).toString();
//		ChangeRequestContent obj=new ChangeRequestContent();
//	    Class cls = Class.forName("com.newgen.omni.jts.util.ChangeRequestContent");
//        Class<?>[] formalParameters = {String.class,String.class,String.class,String.class};
//        Object[] effectiveParameters = new Object[]{input,"",MediaType.APPLICATION_JSON,"http://10.9.9.75:8080/truconverter/api/nepali/convert"};
//        Object newInstance = cls.newInstance();
//        Method getNameMethod = newInstance.getClass().getMethod("getChangeContentStr", formalParameters);
//        String output = (String) getNameMethod.invoke(newInstance, effectiveParameters);
//		
//		//String output=obj.getChangeContentStr(input,"",MediaType.APPLICATION_JSON,"http://10.9.9.75:8080/truconverter/api/nepali/convert");
//		System.out.println(output);
	//}
	
	public String getChangeContentStr(String contentStr,String inputXML,String requestMediaType,String resourceUrl){
		String output=contentStr;
		
//		try{
//			resourceUrl=resourceUrl.trim();
//			if(resourceUrl.equalsIgnoreCase("http://10.9.9.75:8080/truconverter/api/nepali/convert") && requestMediaType.equalsIgnoreCase(MediaType.APPLICATION_JSON)){
//				Object json = new JSONTokener(contentStr).nextValue();
//				if(json instanceof JSONObject){
//					JSONObject jsonInput = (JSONObject)json;
//					Object obj=jsonInput.opt("query");
//					if(obj==null){
//						output=contentStr;
//					}else if(obj instanceof JSONObject){
//						JSONObject jsonInput1 = (JSONObject)obj;
//						JSONArray jsonArray = new JSONArray();
//				        jsonArray.put(jsonInput1);
//				        jsonInput.put("query", jsonArray);
//				        output=jsonInput.toString();
//					}else{
//						output=contentStr;
//					}
//				}
//			}
//			
//		}catch(Exception e){
//			output=contentStr;
//		}
		return output;
	}

}
