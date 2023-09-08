/***************************************************************************
 *	Product		: OmniFlow 7.0
 *	Application	: Web Desktop
 *	Module		: 
 *	File		: JSONArray.java
 *
 *	Purpose:
 *     Converts a JSON Array to String 
 *
 *
 *   Change History:
 *	Problem No		Correction Date	 Changed By			Comments
	----------		---------------	---------		-------------------------------------------
  ***************************************************************************/
package com.newgen.omni.jts.util.json;

import java.util.ArrayList;
import java.util.Iterator;



public class JSONArray extends ArrayList {
	public String toString(){
		ItemList list=new ItemList();
		
		Iterator iter=iterator();
		
		while(iter.hasNext()){
			Object value=iter.next();				
			if(value instanceof String){
				list.add("\""+JSONObject.escape((String)value)+"\"");
			}
			else
				list.add(String.valueOf(value));
		}
		return "["+list.toString()+"]";
	}
		
}
