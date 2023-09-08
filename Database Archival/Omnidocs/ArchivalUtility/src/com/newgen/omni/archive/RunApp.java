/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.newgen.omni.archive;

/**
 *
 * @author pranay.tiwari
 */
public class RunApp {
    public static void main(String args[]){
        try
        {
            ArchiveService as = new ArchiveService();
            int status = as.startArchive();
            if (status == 0)
                System.out.println("Archive Success: "+status);
            else
                System.out.println("Archive fialed: "+status);

        }
        catch(Exception e)
        {
            System.err.println("Exception in Archive");
            e.printStackTrace();
        }
    }

}
