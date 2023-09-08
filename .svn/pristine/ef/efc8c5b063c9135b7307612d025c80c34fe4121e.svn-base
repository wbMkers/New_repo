#!/bin/sh
	clear
###################################################################################################
#######Change following variables to according to your enviornment#################################	
	JAVA_HOME=/app/beav8.1sp2/jdk141_05
	WL_HOME=/app/beav8.1sp2/weblogic81
	WL_DOMAIN=/app/beav8.1sp2/user_domains/thaidomain
 	LIBCLASSPATH=${JAVA_HOME}/jre/lib/rt.jar:${WL_HOME}/server/lib/classes12.jar:${WL_HOME}/server/lib/weblogic.jar:${WL_DOMAIN}/Jars/SecurityAPI.jar:${WL_DOMAIN}/Jars/jce1_2_2.jar
###################################################################################################

####### Give following parameter values in placeholders as described###########################################

# ${JAVA_HOME}/bin/java -cp ${LIBCLASSPATH}:${WL_DOMAIN}/applications/jtsdeployable.jar com.newgen.omni.jts.admin.CabinetCreation.CreateLicense 2 <database service name > 25 <IP of database server> <database port (default 1521)> <cabinetname> <cabinetname> 25


${JAVA_HOME}/bin/java -cp .:${LIBCLASSPATH}:jtsdeployable.jar com.newgen.omni.jts.admin.CabinetCreation.CreateLicense 2 DEDMS1 25 172.18.96.86 1521 thaicab thaicab 25
