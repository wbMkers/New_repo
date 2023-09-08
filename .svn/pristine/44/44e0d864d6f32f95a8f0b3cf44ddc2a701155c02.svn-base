//----------------------------------------------------------------------------
//			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
// Group				: Application - Products
// Product / Project	: iBPS	
// Module				: Server & Services
// File Name			: FileLoader
// Author				: Ambuj Tripathi
// Date written			: 24/07/2018
// Description			: To load all xml file from folder
//----------------------------------------------------------------------------
//		CHANGE HISTORY
//----------------------------------------------------------------------------
// Date		Change By		Change Description (Bug No. If Any)
//----------------------------------------------------------------------------
package com.newgen.omni.jts.util;

import java.io.File;
import java.io.*;
import java.io.FilenameFilter;
import java.net.MalformedURLException;
import java.net.URLClassLoader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import com.newgen.omni.jts.cmgr.XMLParser;
import java.util.LinkedList;

import org.apache.commons.io.FilenameUtils;

import com.newgen.omni.jts.security.*;



class WFFileLoader {
    private ArrayList miscdbProcList;
    private FileInputStream reader;
    private StringBuffer strFilePath;
    
    WFFileLoader(String path){
        miscdbProcList = new ArrayList();
    }

    private Collection listFiles(File directory, FilenameFilter filter, boolean recurse) {
        ArrayList files = new ArrayList();
        File[] entries = directory.listFiles();

        for (int f = 0; f < entries.length; f++) {
            File entry = (File) entries[f];
            if (entry.isFile() && (filter == null || filter.accept(directory, entry.getName()))) {
                files.add(entry);
            }
            if (recurse && entry.isDirectory()) {
                files.addAll(listFiles(entry, filter, recurse));
            }
        }
        return files;
    }
    
    public boolean loadFiles(String path){
    	path=FilenameUtils.normalize(path);
        strFilePath = new StringBuffer(path);
        File dirPath = new File(path);
        FilenameFilter filter = new FileFilter();
        File[] files = null;
        if(dirPath.exists() && dirPath.isDirectory()){
            ArrayList filesAl = (ArrayList)listFiles(dirPath, filter, true);
            files = new File[filesAl.size()];
            filesAl.toArray(files);
            for(int j=0; j<files.length; j++){
                loadFileContent(files[j]);
            }
            return true;
        }
        else if(dirPath.exists() && dirPath.isFile()){
              loadFileContent(dirPath);
              return true;
        }
        
        if(!dirPath.exists()){
            return false;
        }
        return true;
     }

    public void loadFileContent(File file){
    	 BufferedReader breader=null;
        String tempStr = "";
            try{
            	breader= new BufferedReader(new FileReader(file));
                StringBuffer stringbuffer = new StringBuffer(200);
		
				char ac[] = null;
                do{
                    ac = new char[1024];
                    int i = breader.read(ac, 0, 1024);
                    if(i == -1)
                        break;
                    stringbuffer.append(ac);
                    ac = null;
                }
                while(true);
                breader.close();
                XMLParser xmlparser = new XMLParser(stringbuffer.toString());
                int miscStartIndex = xmlparser.getStartIndex("MiscScriptName", 0, 0);
                int miscEndIndex = xmlparser.getEndIndex("MiscScriptName", 0, 0);
                
				if(miscStartIndex < miscEndIndex) {
					int noOfFields = xmlparser.getNoOfFields("Name", miscStartIndex, miscEndIndex);
					tempStr = xmlparser.getFirstValueOf("Name", miscStartIndex);
					if(!tempStr.equals(""))
						miscdbProcList.add(tempStr.trim());
					while(--noOfFields > 0){
						tempStr = xmlparser.getNextValueOf("Name");
								  if(!tempStr.equals(""))
							miscdbProcList.add(tempStr.trim());
					}
                }
            }
			catch(IOException e){
				//e.printStackTrace();
            }finally{
            	try{
            		if(breader!=null){
            			breader.close();
            			breader=null;
            		}
            	}catch(Exception e){
            		
            	}
            }
    }
    
    public String getProcedure(int procId, String procedurePath, boolean decrypt) {
        StringBuffer stringbuffer = new StringBuffer();
		String buf = new String();
        if(procedurePath != null)
            stringbuffer.append(procedurePath);
        else
            stringbuffer.append(strFilePath.toString());
        
		stringbuffer.append(File.separatorChar);
		stringbuffer.append((String)miscdbProcList.get(procId));
	
        try{
			java.io.File file   = new java.io.File(FilenameUtils.normalize(stringbuffer.toString()));	
			//System.out.println(procId + " = " + stringbuffer.toString());
		    reader = new FileInputStream(FilenameUtils.normalize(stringbuffer.toString()));
		    long len= file.length();
		    byte ac[] = new byte[(int) len];
		    int count=reader.read(ac);		
		    if(count<=0){
		    	count++;
		    }
		    if (!decrypt)
				buf = new String(ac);
		    else	
   				buf = JTSSecurity.decode(ac,"8859_1");
        }
        catch(Exception e){}
        finally{
				try{
                reader.close();
				}catch(Exception e) { }
				reader = null;
        }		
        return buf.replace('\r',' ');
    }
    
    public int getMaxProcedureId(){
		return miscdbProcList.size();
    }
    
    
}

class FileFilter implements FilenameFilter {
    String[] ext = null;

    FileFilter(){
		ext = new String[]{"xml"};// array of file types
    }
	
    public boolean accept(File dir, String name) {
        for(int i=0; i< ext.length; i++){
            if(name.toUpperCase().endsWith(ext[i].toUpperCase())){
                return (true);
            }
        }
        return(false);
    }
}
