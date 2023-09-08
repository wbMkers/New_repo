/* --------------------------------------------------------------------------
                 NEWGEN SOFTWARE TECHNOLOGIES LIMITED
             Group				: Application - Products
             Product / Project	: WorkFlow 6.1.2
             Module				: Omniflow Server
             File Name			: WFBeanDeserializer.java
 ----------------------------------------------------------------------------
                          CHANGE HISTORY
 ----------------------------------------------------------------------------
 Date		    Change By		Change Description (Bug No. If Any)

 --------------------------------------------------------------------------*/

/**
 * Apache Axis 1.2.1 code takes property name case sensitive when compared to
 * the element in SOAP response for complex data structures
 * Hence BeanDeserializer has been written ignore the case
 *
 * Source code reference for Apache axis 1.2.1
 * http://www.mirrorgeek.com/apache.org/ws/axis/1_2_1/axis-src-1_2_1.zip
 */

package org.apache.axis.encoding.ser;

import org.apache.axis.encoding.ser.BeanDeserializer;
import org.apache.axis.Constants;
import org.apache.axis.description.ElementDesc;
import org.apache.axis.description.FieldDesc;
import org.apache.axis.description.TypeDesc;
import org.apache.axis.encoding.ConstructorTarget;
import org.apache.axis.encoding.DeserializationContext;
import org.apache.axis.encoding.Deserializer;
import org.apache.axis.message.MessageElement;
import org.apache.axis.message.SOAPHandler;
import org.apache.axis.soap.SOAPConstants;
import org.apache.axis.utils.BeanPropertyDescriptor;
import org.apache.axis.utils.Messages;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import javax.xml.namespace.QName;
import java.util.Map;

public class WFBeanDeserializer extends BeanDeserializer {

    public WFBeanDeserializer(Class javaType, QName xmlType) {
        super(javaType, xmlType);
    }

    public WFBeanDeserializer(Class javaType, QName xmlType, TypeDesc typeDesc) {
        super(javaType, xmlType, typeDesc);
    }

    public WFBeanDeserializer(Class javaType, QName xmlType, TypeDesc typeDesc, Map propertyMap) {
        super(javaType, xmlType, typeDesc, propertyMap);
    }

    /**
     * Deserializer interface called on each child element encountered in
     * the XML stream.
     * @param namespace is the namespace of the child element
     * @param localName is the local name of the child element
     * @param prefix is the prefix used on the name of the child element
     * @param attributes are the attributes of the child element
     * @param context is the deserialization context.
     * @return is a Deserializer to use to deserialize a child (must be
     * a derived class of SOAPHandler) or null if no deserialization should
     * be performed.
     */
    public SOAPHandler onStartChild(String namespace,
                                    String localName,
                                    String prefix,
                                    Attributes attributes,
                                    DeserializationContext context) throws SAXException {

//        SOAPHandler myDSer = null;
//        try {
//            myDSer = (SOAPHandler)super.onStartChild(namespace, localName, prefix, attributes, context);
//        } catch (SAXException ex) {
//            ex.printStackTrace();
//            System.out.println("Exception from Super class .......... ");
//        }

        handleMixedContent();

        BeanPropertyDescriptor propDesc = null;
        FieldDesc fieldDesc = null;

        SOAPConstants soapConstants = context.getSOAPConstants();
        String encodingStyle = context.getEncodingStyle();
        boolean isEncoded = Constants.isSOAP_ENC(encodingStyle);

        QName elemQName = new QName(namespace, localName);
        // The collectionIndex needs to be reset for Beans with multiple arrays
        if ((prevQName == null) || (!prevQName.equals(elemQName))) {
            collectionIndex = -1;
        }

        boolean isArray = false;
        QName itemQName = null;
        if (typeDesc != null) {
            // Lookup the name appropriately (assuming an unqualified
            // name for SOAP encoding, using the namespace otherwise)
            String fieldName = typeDesc.getFieldNameForElement(elemQName,
                                                               isEncoded);
            propDesc = (BeanPropertyDescriptor) propertyMap.get(fieldName);
            fieldDesc = typeDesc.getFieldByName(fieldName);

            if (fieldDesc != null) {
                ElementDesc element = (ElementDesc) fieldDesc;
                isArray = element.isMaxOccursUnbounded();
                itemQName = element.getItemQName();
            }
        }

        if (propDesc == null) {
            // look for a field by this name.
            propDesc = (BeanPropertyDescriptor) propertyMap.get(localName);
        }

        /**
         * Code added for making property case insensitive....... - Ruhi
         */
        if (propDesc == null) {
            // look for a field by this name.
            propDesc = (BeanPropertyDescriptor) propertyMap.get(localName.toUpperCase());
        }

        // try and see if this is an xsd:any namespace="##any" element before
        // reporting a problem
        if (propDesc == null ||
            (((prevQName != null) && prevQName.equals(elemQName) &&
              !(propDesc.isIndexed() || isArray)
              && getAnyPropertyDesc() != null))) {
            // try to put unknown elements into a SOAPElement property, if
            // appropriate
            prevQName = elemQName;
            propDesc = getAnyPropertyDesc();
            if (propDesc != null) {
                try {
                    MessageElement[] curElements = (MessageElement[]) propDesc.get(value);
                    int length = 0;
                    if (curElements != null) {
                        length = curElements.length;
                    }
                    MessageElement[] newElements = new MessageElement[length + 1];
                    if (curElements != null) {
                        System.arraycopy(curElements, 0,
                                         newElements, 0, length);
                    }
                    MessageElement thisEl = context.getCurElement();

                    newElements[length] = thisEl;
                    propDesc.set(value, newElements);
                    // if this is the first pass through the MessageContexts
                    // make sure that the correct any element is set,
                    // that is the child of the current MessageElement, however
                    // on the first pass this child has not been set yet, so
                    // defer it to the child SOAPHandler
                    if (!localName.equals(thisEl.getName())) {
                        return new SOAPHandler(newElements, length);
                    }
                    return new SOAPHandler();
                } catch (Exception e) {
                    throw new SAXException(e);
                }
            }
        }

        if (propDesc == null) {
            // No such field
            throw new SAXException(
                Messages.getMessage("badElem00", javaType.getName(),
                                    localName));
        }

        prevQName = elemQName;
        // Get the child's xsi:type if available
        QName childXMLType = context.getTypeFromAttributes(namespace,
                                                           localName,
                                                           attributes);

        String href = attributes.getValue(soapConstants.getAttrHref());
        Class fieldType = propDesc.getType();

        // If no xsi:type or href, check the meta-data for the field
        if (childXMLType == null && fieldDesc != null && href == null) {
            childXMLType = fieldDesc.getXmlType();
            if (itemQName != null) {
                // This is actually a wrapped literal array and should be
                // deserialized with the ArrayDeserializer
                childXMLType = Constants.SOAP_ARRAY;
                fieldType = propDesc.getActualType();
            } else {
                childXMLType = fieldDesc.getXmlType();
            }
        }

        // Get Deserializer for child, default to using DeserializerImpl
        Deserializer dSer = getDeserializer(childXMLType,
                                            fieldType,
                                            href,
                                            context);

        // It is an error if the dSer is not found - the only case where we
        // wouldn't have a deserializer at this point is when we're trying
        // to deserialize something we have no clue about (no good xsi:type,
        // no good metadata).
        if (dSer == null) {
            dSer = context.getDeserializerForClass(propDesc.getType());
        }

        // Fastpath nil checks...
        if (context.isNil(attributes)) {
            if (propDesc != null && (propDesc.isIndexed() || isArray)) {
                if (!((dSer != null) && (dSer instanceof ArrayDeserializer))) {
                    collectionIndex++;
                    dSer.registerValueTarget(new BeanPropertyTarget(value,
                                                                    propDesc, collectionIndex));
                    addChildDeserializer(dSer);
                    return (SOAPHandler) dSer;
                }
            }
            return null;
        }

        if (dSer == null) {
            throw new SAXException(Messages.getMessage("noDeser00",
                                                       childXMLType.toString()));
        }

        if (constructorToUse != null) {
            if (constructorTarget == null) {
                constructorTarget = new ConstructorTarget(constructorToUse, this);
            }
            dSer.registerValueTarget(constructorTarget);
        } else if (propDesc.isWriteable()) {
            // If this is an indexed property, and the deserializer we found
            // was NOT the ArrayDeserializer, this is a non-SOAP array:
            // <bean>
            //   <field>value1</field>
            //   <field>value2</field>
            // ...
            // In this case, we want to use the collectionIndex and make sure
            // the deserialized value for the child element goes into the
            // right place in the collection.

            // Register value target
            if ((itemQName != null || propDesc.isIndexed() || isArray) && !(dSer instanceof ArrayDeserializer)) {
                collectionIndex++;
                dSer.registerValueTarget(new BeanPropertyTarget(value,
                                                                propDesc, collectionIndex));
            } else {
                // If we're here, the element maps to a single field value,
                // whether that be a "basic" type or an array, so use the
                // normal (non-indexed) BeanPropertyTarget form.
                collectionIndex = -1;
                dSer.registerValueTarget(new BeanPropertyTarget(value,
                                                                propDesc));
            }
        }

        // Let the framework know that we need this deserializer to complete
        // for the bean to complete.
        addChildDeserializer(dSer);

        return (SOAPHandler) dSer;
    }
}
