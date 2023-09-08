/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.newgen.omni.jts.util;

/**
 *
 */
public class WFTaskThreadLocal {

   public static final ThreadLocal userThreadLocal = new ThreadLocal();

    public static void set(Integer taskId) {

        userThreadLocal.set(taskId);

}

    public static void unset() {

        userThreadLocal.remove();

}

    public static Integer get() {
    	Integer taskId =(Integer)userThreadLocal.get();
    	return taskId==null? 0 :taskId ;

}


}
