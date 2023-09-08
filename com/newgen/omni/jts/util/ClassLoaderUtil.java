/* --------------------------------------------------------------------------
                    NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: Omniflow 10.1
Module				: Omniflow Server
File Name			: ClassLoaderUtil.java
Author				: Mohnish Chopra
Date written		: 16/09/2013
Description         : Utility class for dynamic class loading . 
					  Introduced for Bug 40104 - WebService : Regsitered webservice is not executing at web client
                      
----------------------------------------------------------------------------
CHANGE HISTORY
----------------------------------------------------------------------------
Date		    Change By		Change Description (Bug No. If Any)

--------------------------------------------------------------------------*/
package com.newgen.omni.jts.util;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

import org.apache.commons.io.FilenameUtils;

public class ClassLoaderUtil {

	// Log object
	// Parameters
	private static final Class[] parameters = new Class[]{URL.class};

	/**
	 * Add file to CLASSPATH
	 * @param s File name
	 * @throws IOException  IOException
	 */
	public static void addFile(String s) throws IOException {
		File f = new File(FilenameUtils.normalize(s));
		addFile(f);
	}

	/**
	 * Add file to CLASSPATH
	 * @param f  File object
	 * @throws IOException IOException
	 */
	public static void addFile(File f) throws IOException {
		addURL(f.toURL());
	}

	/**
	 * Add URL to CLASSPATH
	 * @param u URL
	 * @throws IOException IOException
	 */
	public static void addURL(URL u) throws IOException {

		URLClassLoader sysLoader = (URLClassLoader) ClassLoader.getSystemClassLoader();
		Class sysclass = URLClassLoader.class;
		try {
			Method method = sysclass.getDeclaredMethod("addURL", parameters);
			method.setAccessible(true);
			method.invoke(sysLoader, new Object[]{u});
		} catch (Exception t) {/*A catch statement should never catch throwable since it includes errors-- Shweta Singhal*/
			//t.printStackTrace();
			throw new IOException("Error, could not add URL to system classloader");
		}
	}

}
