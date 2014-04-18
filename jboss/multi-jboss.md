This document explains how you can create multiple instances of jboss on one machine, then update the configuration/init script so that it starts up multiple instances of jboss on one host:


Refer to ./docs/examples/binding-manager/sample-bindings.xml

For more information on specifics of [ ports-00 (8080) ]  [ ports-01 (8180) ]  [  ports-02 (8280) ] [ ports-03 (8380) ]

so in effect there can be 4 instances of jboss running on any 1 physical box

The layout has to be:
```
PATH_TO_JBOSS/server/jbs0

PATH_TO_JBOSS/server/jbs1

PATH_TO_JBOSS/server/jbs2

PATH_TO_JBOSS/server/jbs3
```

Attached is the start up script which works exactly like the tomcat startup script

```
/etc/init.d/jboss stop       (stops all jbs(0|1|2|3) instances)

/etc/init.d/jboss start       (starts all jbs(0|1|2|3) instances)

/etc/init.d/jboss start-jbs(0|1|2|3)       (starts specific instance )

/etc/init.d/jboss stop-jbs(0|1|2|3)       (stops specific instance )
```

# JBOSS Configuration  changes:

jboss init script:
Look for JBOSS_CONF= and change it to look like below:
```
N=$2;
JBOSS_CONF=${JBOSS_CONF:-"$N"}
```
now you can do
```
/etc/init.d/jboss start jbs1
/etc/init.d/jboss start jbs2
```


1. Edit run.sh

vi /opt/jboss/bin/run.sh  (2 changes required)

(within the case switch for -c there is the new INSTANCE line added)
1. ) within top case -c switch
```
 case "$SWITCH" in
            -c)
                eval JBOSSCONF=\$`expr $arg_count + 1`
                CONF_SPECIFIED=true
                INSTANCE=$(echo $JBOSSCONF | awk -F 'jbs' '{print $2}');
``` 
 
 
2) on Line 98 (or any other java exports) add the -Djboss.instance=$INSTANCE
```
# Force use of IPv4 stackJAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true -Djboss.instance=$INSTANCE"
``` 

3. vi /opt/jboss/server/jbs1/conf/jboss-service.xml

Search for Binding, you will find a similar block to this, under the comment add the following: (ensuring ServerName matches what we have here)
```
<mbean code="org.jboss.services.binding.ServiceBindingManager"
     name="jboss.system:service=ServiceBindingManager">
     <attribute name="ServerName">ports-0${jboss.instance}</attribute>
     <attribute name="StoreURL">${jboss.home.url}/docs/examples/binding-manager/sample-bindings.xml</attribute>
     <attribute name="StoreFactoryClassName">
       org.jboss.services.binding.XMLServicesStoreFactory
     </attribute>
   </mbean>
```
Thats all -

jbs0 runs on default jboss ports

jbs1 which runs on 100 ports up from original

jbs2 will be 200 hundred ports up

jbs3 will be 300 ports up

cd /opt/jboss/server;

$ ls -ld jbs*
```
drwxr-xr-x 8 root  root  4096 May 23 10:48 jbs0
drwxr-xr-x 8 jboss jboss 4096 May 22 16:54 jbs1
drwxr-xr-x 8 jboss jboss 4096 May 22 15:47 jbs2
drwxr-xr-x 8 root  root  4096 May 23 10:48 jbs3
```
 
```
$ chown -R jboss:jboss jbs3
$ chown -R jboss:jboss jbs0
$ cd /etc/init.d/
```

$ ./jboss.new start
```
Starting All JBOSS
Working on >jbs0<
JBOSS_CMD_START = cd /opt/jboss/bin; /opt/jboss/bin/run.sh -c jbs0 -b 0.0.0.0
Delay 1 before next one....
Working on >jbs1<
WARNING: location for saving console log invalid: /dev/null
WARNING: ignoring it and using /dev/null
JBOSS_CMD_START = cd /opt/jboss/bin; /opt/jboss/bin/run.sh -c jbs1 -b 0.0.0.0
Delay 1 before next one....
Working on >jbs2<
WARNING: location for saving console log invalid: /dev/null
WARNING: ignoring it and using /dev/null
JBOSS_CMD_START = cd /opt/jboss/bin; /opt/jboss/bin/run.sh -c jbs2 -b 0.0.0.0
Delay 1 before next one....
Working on >jbs3<
WARNING: location for saving console log invalid: /dev/null
WARNING: ignoring it and using /dev/null
JBOSS_CMD_START = cd /opt/jboss/bin; /opt/jboss/bin/run.sh -c jbs3 -b 0.0.0.0
Delay 1 before next one....
 $
```

 $ ps auwx|grep java
```
jboss    18601 83.6  8.4 2976412 262760 ?      Sl   10:51   0:08 /usr/lib/jvm/java/bin/java -Dprogram.name=run.sh -server -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.net.preferIPv4Stack=true -Djboss.instance=0 -Djava.library.path=/opt/jboss/bin/native -Djava.endorsed.dirs=/opt/jboss/lib/endorsed -classpath /opt/jboss/bin/run.jar:/usr/lib/jvm/java/lib/tools.jar org.jboss.Main -c jbs0 -b 0.0.0.0
jboss    18668 72.8  6.5 2901668 204120 ?      Sl   10:51   0:06 /usr/lib/jvm/java/bin/java -Dprogram.name=run.sh -server -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.net.preferIPv4Stack=true -Djboss.instance=1 -Djava.library.path=/opt/jboss/bin/native -Djava.endorsed.dirs=/opt/jboss/lib/endorsed -classpath /opt/jboss/bin/run.jar:/usr/lib/jvm/java/lib/tools.jar org.jboss.Main -c jbs1 -b 0.0.0.0
jboss    18816 22.2  1.4 2861648 46316 ?       Sl   10:51   0:00 /usr/lib/jvm/java/bin/java -Dprogram.name=run.sh -server -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.net.preferIPv4Stack=true -Djboss.instance=2 -Djava.library.path=/opt/jboss/bin/native -Djava.endorsed.dirs=/opt/jboss/lib/endorsed -classpath /opt/jboss/bin/run.jar:/usr/lib/jvm/java/lib/tools.jar org.jboss.Main -c jbs2 -b 0.0.0.0
jboss    18826 49.6  1.6 2860532 51724 ?       Sl   10:51   0:01 /usr/lib/jvm/java/bin/java -Dprogram.name=run.sh -server -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.net.preferIPv4Stack=true -Djboss.instance=3 -Djava.library.path=/opt/jboss/bin/native -Djava.endorsed.dirs=/opt/jboss/lib/endorsed -classpath /opt/jboss/bin/run.jar:/usr/lib/jvm/java/lib/tools.jar org.jboss.Main -c jbs3 -b 0.0.0.0
root     18854  0.0  0.0  61232   748 pts/0    R+   10:51   0:00 grep java
```

ps auwx|grep java|awk '{print "/usr/sbin/lsof -P -p"$2" |grep LISTEN"}'

```
/usr/sbin/lsof -P -p18601 |grep LISTEN
/usr/sbin/lsof -P -p18668 |grep LISTEN
/usr/sbin/lsof -P -p18816 |grep LISTEN
/usr/sbin/lsof -P -p18826 |grep LISTEN
/usr/sbin/lsof -P -p19267 |grep LISTEN
```

