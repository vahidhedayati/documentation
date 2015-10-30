#!/bin/bash 
########
# ---------- tomcat-apr.sh tomcat
# Bash script to download latest openSSL tomcat7 OracleJDK7
# Really to be tested on a new install
# Enable tomcat APR module
# Configure Basic SSL and enable default ssl certs to work 
# with a tomcat application running on port 8443.
# Script can just be executed and will install everything chowned to underlying user
# Script must be run as root !
# usage:
# ./tomcat-apr.sh
# or 
# ./tomcat-apr.sh apache
# second command will then chown files to apache user so user must exist.
# All files downloaded installed in $BASE
#######

#######
#Variables locations
BASE="/opt"
TOMCAT="$BASE/tomcat7"
JDK="$BASE/jdk7"

# SSL Template configuration
# if you choose to generateOwnSSL 
# bottom of the script
domain="server"
commonname="$domain"

country="UK"
state="GB"
locality="London"
organization="My Company"
organizationalunit="EastSide"
email="noreply@myCompany.com"
password="tomcat"
#######

#######
# script configuration
#check if user is root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# set chown user
username=$1
CHOWNUSER="${username:-$USER}"
#######





#####################################
#Functions below
#####################################

##
#fixRepo
# replaces https with http in various repo files
function fixRepo() { 
	#sort out https issue so it can download from repo
	cd /etc/yum.repos.d/
	sed -e 's/https/http/g' fedora-updates.repo > fedora-updates.repo1 && mv -f fedora-updates.repo1 fedora-updates.repo
	sed -e 's/https/http/g' fedora.repo > fedora.repo1 && mv -f fedora.repo1 fedora.repo
}



##
#installSoftware installs APR 
# and from source: (OPEN-SSL 1.0.2d / ORACLE-JDK-7u_79 / APACHE-Tomcat-7.0.65)
function installSoftware() { 
	#install apr
	yum -y install apr-devel apr-util-devel
	installSSL;
	installJDK;
	installTomcat;

}

function installSSL() { 
	#install repo stuff needed
	yum -y install gcc wget zlib-devel
	cd $BASE
	#openssl from scratch
	wget http://www.openssl.org/source/openssl-1.0.2d.tar.gz
	tar -xvzf openssl-1.0.2d.tar.gz
	cd openssl-1.0.2d
	./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
	make
	make install
}

function checkSSL() { 
	if openssl version 2>/dev/null |grep -q "OpenSSL 1.0.2d"; then 
		echo "------------------------------------------------------------------------------------------------------"
		echo "Success -- we have OpenSSL 1.0.2d Installed ----------------------------------------------------------"
		echo "------------------------------------------------------------------------------------------------------"
	else
		echo "------------------------------------------------------------------------------------------------------"
		echo "ERROR ERROR ERROR - OpenSSL 1.0.2d  is not Installed -------------------------------------------------"
		echo "------------------------------------------------------------------------------------------------------"
	fi
}

function installJDK() { 
	cd $BASE
	#get the software
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"
	tar -xvzf jdk-7u79-linux-x64.tar.gz 
	mv jdk1.7.0_79 $JDK
	# JDK get oracle version, seen stuff about security and open-jdk.
	# http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
	# Issues in getting JDK ? then yum install for open-jdk:
	# yum install java-1.7.0-openjdk.i686 java-1.7.0-openjdk-devel.x86_64
}


function installTomcat() { 
	# Download Tomcat 7.0.65:
	cd $BASE
	wget http://mirror.vorboss.net/apache/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz -O apache-tomcat-7.0.65.tar.gz
	tar -xvzf apache-tomcat-7.0.65.tar.gz
	ln -s apache-tomcat-7.0.65 tomcat7
	cd $TOMCAT/bin
	tar -xvzf tomcat-native.tar.gz
	cd tomcat-native-1.1.33-src/jni/native/
	export JAVA_HOME=$JDK
	./configure --with-apr=`which apr-1-config` --with-java-home=$JAVA_HOME --with-ssl=/usr
	make && make install
	cd $BASE
	chown -R $CHOWNUSER:$CHOWNUSER apache-tomcat-7.0.65

}

## 
# makeSSLCert
# Will generate dummy SSL in /etc/ssl/certs/called localhost.crt
function makeSSLCert() { 
	# This is done to generate my ssl certs:
	cd /etc/ssl/certs/
	./make-dummy-cert localhost.crt
	chown $CHOWNUSER:$CHOWNUSER localhost.crt 
}



##
#generateOwnSSL
# will run openssl to generate csr key files which it then
# puts into one file called localhost.crt
# This way no config changes required when writing tomcat configuration
# automatd process to generate internal custom ssl keys
function generateOwnSSL() { 
	cd /etc/ssl/certs/
	echo "Generating key request for $domain"
	openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout
	echo "Removing passphrase from key"
	openssl rsa -in $domain.key -passin pass:$password -out $domain.key
	echo "Creating CSR"
	openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
echo "C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
	openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt
	chown $CHOWNUSER:$CHOWNUSER $domain.*
	if [ -f localhost.crt ]; then
	 backup="localhost.crt.$$"
	 cp localhost.crt $backup
	 echo "File backed up to $backup"
	fi
	cat $domain.* > localhost.crt
}



##
# updateConfig
# will update the server.xml and add APR config to it 
# with the basic crt created above
function updateConfig() { 
	cd $TOMCAT/conf
	# edit server.xml add under listeners line 35:
ed -s server.xml << EOF
35a

 <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
.
92a
 
 
 <!--
 
 Ciphers: The enabled block attempts to load in the very latest ciphers which should disable 
 ciphers currently marked with issues. 
 
 Only issue may arise when an end user with very old technology attempts to make an ssl connection with their
 ciphers not supported.
 
 What appears to be a larger set of ciphers DHE ciphers are known to have issues, with this config the default will still be ECDH
  SSLCipherSuite="ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK"

 -->
 
 
 <Connector port="8443" maxHttpHeaderSize="8192"
    maxThreads="150"
    enableLookups="false" disableUploadTimeout="true"
    acceptCount="100" scheme="https" secure="true"
    SSLEnabled="true"
    SSLCertificateFile="/etc/ssl/certs/localhost.crt"
    SSLCertificateKeyFile="/etc/ssl/certs/localhost.crt"
    SSLCipherSuite="ECDH+AESGCM:ECDH+AES256:ECDH+AES128:RSA+AES:!aNULL:!MD5:!DSS"
    SSLDisableCompression="true"
    SSLHonorCipherOrder="true"
    SSLVerifyClient="optional"
    SSLProtocol="TLSv1+TLSv1.1+TLSv1.2"
    server="Prism Server"
    connectionTimeout="60000"
    keepAliveTimeout="60000"
    maxKeepAliveRequests="100"
    maxPostSize="2097152"
    maxHeaderCount="50"
    allowTrace="false" />
.
w
q
EOF

}

##
# startTomcat called when all done
function startTomCat() { 
	cd $TOMCAT/bin/
	export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
	export JAVA_HOME=$JDK
	./startup.sh
}

function echoExports() { 

echo "----------------------------------------------------------------------------
Thanks nearly done -- just to remind you that from now on in order to run tomcat
you need to run the following:

 export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
 export JAVA_HOME=$JDK
 cd $TOMCAT/bin
 ./startup.sh



Check https://localhost:8443/ on your browser

Also note under vanilla fedora you may need to disable iptables 
to access the host from remote machine so run

/sbin/service iptables stop



Thanks hope it has all worked 
----------------------------------------------------------------------------------"


}
#######
#Main script
# Fixes underlying SSL issues which stops yum from working makes https into http
fixRepo;

# Install various software
installSoftware;

#Generate dummy SSL
# This option creates default ssl certs provided out of the box
# makeSSLCert

# This option attempts to generate custom ssl certificates 
generateOwnSSL;

# Update tomcat server.xml
updateConfig;

#Start tomcat server
startTomCat;

# Checks version of OpenSSL installed
checkSSL;

# Returns useful info to end user
echoExports;

#######
