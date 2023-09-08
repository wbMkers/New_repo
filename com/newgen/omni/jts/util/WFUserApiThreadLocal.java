/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.newgen.omni.jts.util;

/**
 *
 * @author sajid.khan
 */
public class WFUserApiThreadLocal {

   public static final ThreadLocal userThreadLocal = new ThreadLocal();

    public static void set(WFUserApiContext userApiContext) {

        userThreadLocal.set(userApiContext);

}

    public static void unset() {

        userThreadLocal.remove();

}

    public static WFUserApiContext get() {

        return (WFUserApiContext)userThreadLocal.get();

}


}
