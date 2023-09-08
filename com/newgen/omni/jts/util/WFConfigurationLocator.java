package com.newgen.omni.jts.util;

import java.net.URL;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import java.io.File;

@Deprecated
public final class WFConfigurationLocator {

    private static final WFConfigurationLocator configInstance = new WFConfigurationLocator();

    private WFConfigurationLocator() {
    }

    public static WFConfigurationLocator getSharedInstance() {
        return configInstance;
    }

    public String getPath(String sLocationName) {
        String sLocationPath;
        try {
            switch (sLocationName) {
                case "Omniflow_Logs_Config_Location":
                    sLocationPath = WFConfigLocator.getInstance().getPath(Location.IBPS_LOG);
                    break;
                case "Omniflow_Config_Location":
                default:
                    sLocationPath = WFConfigLocator.getInstance().getPath(Location.IBPS_CONFIG);
                    break;
            }
        } catch (Exception | Error ex) {
            System.err.println("[wfsshared.jar] [WFConfigurationLocator.class] [getPath(String sLocationName)]");
            ex.printStackTrace(System.err);
            sLocationPath = System.getProperty("user.dir");
        }
        return sLocationPath;
    }

    public static String getClassLocation(URL url) {
        String location = "";
        try {
            location = url.toString();
            if (location.startsWith("jar")) {
                url = ((java.net.JarURLConnection) url.openConnection()).getJarFileURL();
            }
            if (File.separatorChar == '/') {
                location = (url.getPath()).substring(0, (url.getPath()).lastIndexOf('/') + 1);
            } else {
                location = (url.getPath()).substring(1, (url.getPath()).lastIndexOf('/') + 1);
            }
        } catch (Exception | Error ex) {
            System.err.println("[wfsshared.jar] [WFConfigurationLocator.class] [getClassLocation(URL url)]");
            ex.printStackTrace(System.err);
        }
        return location;
    }

    public static String getLibLocation(URL url) {
        String location = "";
        String path;
        try {
            path = url.getPath();
            path = path.replaceAll("%20", " ");
            if (path.contains(".jar")) {
                path = path.substring(0, path.indexOf(".jar") + ".jar".length());
            }

            if (File.separatorChar == '/') {
                location = (path).substring(0, (path).lastIndexOf('/') + 1);
            } else if (path.indexOf("file") == 0) {
                location = (path).substring(6, (path).lastIndexOf('/') + 1);
            } else {
                location = (path).substring(1, (path).lastIndexOf('/') + 1);
            }
        } catch (Exception | Error ex) {
            System.err.println("[wfsshared.jar] [WFConfigurationLocator.class] [getLibLocation(URL url)]");
            ex.printStackTrace(System.err);
        }
        String osName = System.getProperty("os.name");
        if (osName.equalsIgnoreCase("Linux")) {
            location = location.replace("file:", "");
        }
        return location;
    }

}
