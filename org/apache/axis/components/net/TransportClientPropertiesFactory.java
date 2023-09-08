/*
 * Copyright 2002-2004 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.axis.components.net;

import org.apache.axis.AxisProperties;
import org.apache.axis.components.logger.LogFactory;
import org.apache.commons.logging.Log;

import java.util.HashMap;


/**
 * @author Richard A. Sitze
 */
public class TransportClientPropertiesFactory {
    protected static Log log =
            LogFactory.getLog(SocketFactoryFactory.class.getName());

    private static HashMap cache = new HashMap();
    private static HashMap defaults = new HashMap();

    static {
        defaults.put("http", DefaultHTTPTransportClientProperties.class);
        defaults.put("https", DefaultHTTPSTransportClientProperties.class);
    }

    public static TransportClientProperties create(String protocol)
    {
        TransportClientProperties tcp =
            (TransportClientProperties)cache.get(protocol);

        if (tcp == null) {
            tcp = (TransportClientProperties)
                AxisProperties.newInstance(TransportClientProperties.class,
                                           (Class)defaults.get(protocol));

            if (tcp != null) {
                cache.put(protocol, tcp);
            }
        }

        return tcp;
    }

    /**
     * New method exposed, as proxy settings were cached for all URLs
     * Causing error if a URL has to be invoked without using proxy after a one that
     * requires the same and vice versa. Axis does not provide any method in this version
     * to clear the cache.
     * The class file has been modified in Axis.jar in vss. Original jar can
     * again be extracted from vss.
     * Bug # WFS_6.1.2_047
     * - Ruhi Hira
     */
    public static void clearCache(){
        for(java.util.Iterator itr = cache.entrySet().iterator(); itr.hasNext(); ){
            java.util.Map.Entry entry = (java.util.Map.Entry)itr.next();
        }
        //System.out.println(" [TransportClientPropertiesFactory] clearing cache ....... ");
        cache = new HashMap();
    }
}
