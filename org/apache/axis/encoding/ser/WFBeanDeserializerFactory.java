/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFBeanDeserializerFactory.java
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

/**
 * Apache Axis 1.2.1 code takes property name case sensitive when compared to
 * the element in SOAP response for complex data structures
 * Hence BeanDeserializerFactory has been written that gives
 * WFBeanDeserializer object.
 *
 * Source code reference for Apache axis 1.2.1
 * http://www.mirrorgeek.com/apache.org/ws/axis/1_2_1/axis-src-1_2_1.zip
 */

package org.apache.axis.encoding.ser;

import org.apache.axis.description.TypeDesc;
import org.apache.axis.encoding.Deserializer;
import org.apache.axis.utils.BeanPropertyDescriptor;
import org.apache.axis.utils.BeanUtils;
import org.apache.axis.utils.JavaUtils;

import javax.xml.namespace.QName;
import java.util.Map;

public class WFBeanDeserializerFactory extends BaseDeserializerFactory{

    protected transient TypeDesc typeDesc = null;
    protected transient Map propertyMap = null;

    public WFBeanDeserializerFactory(Class javaType, QName xmlType) {
        super(WFBeanDeserializer.class, xmlType, javaType);

        // Sometimes an Enumeration class is registered as a Bean.
        // If this is the case, silently switch to the EnumDeserializer
        if (JavaUtils.isEnumClass(javaType)) {
            deserClass = EnumDeserializer.class;
        }

        typeDesc = TypeDesc.getTypeDescForClass(javaType);
        propertyMap = getProperties(javaType, typeDesc);
    }

   /**
     * Optimize construction of a BeanDeserializer by caching the
     * type descriptor and property map.
     */
    protected Deserializer getGeneralPurpose(String mechanismType) {
        if (javaType == null || xmlType == null) {
           return super.getGeneralPurpose(mechanismType);
        }

        if (deserClass == EnumDeserializer.class) {
           return super.getGeneralPurpose(mechanismType);
        }

        return new WFBeanDeserializer(javaType, xmlType, typeDesc, propertyMap);
    }

    public static Map getProperties(Class javaType, TypeDesc typeDesc) {
        Map propertyMap = BeanDeserializerFactory.getProperties(javaType, typeDesc);

        BeanPropertyDescriptor[] propertyDescriptors = BeanUtils.getPd(javaType, typeDesc);
        for (int i = 0; i < propertyDescriptors.length; i++) {
            BeanPropertyDescriptor descriptor = propertyDescriptors[i];
            propertyMap.put(descriptor.getName().toUpperCase(), descriptor);
        }

        return propertyMap;
    }
}
