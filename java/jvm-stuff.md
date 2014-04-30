JVM Document
===================

# List java processes:

To list java processes on either local machine or remote machine use:

>jps 


To list procceses:
>jps -l localhost

localhost is not needed, put in to show where remote host would be put in.


# Thread dump a java process:

Thread dump returns a dump of all active/live threads within a JVM, this can/should be run 
multiple times during when a given JVM is possibly having issues, it will show any thread deadlocks.
To gain access to thread dumps run:

>kill -3 {JVM PID}

Or

>jstack {jvm PID}

The results will be sent to catalina.out and it is then up to you to possibly take each dump and do a diff on them to see what is going on.

You may find you are root or someone else and it will not return your results so you should try adding:

> su - tomcat -c "jstack {jvm PID}"


# Heap dumps:

Heap dumps simply dump the entire state of a JVM pid at the given time and what resided in memory, what classes were called, how long and how much memory each class took etc.
If done in regular intervals it can help identify memory leaks.


>su - tomcat -c "jmap -dump:file=/var/tmp/a.data  {jvm PID}"

```
Dumping heap to /var/tmp/a.data ...
Heap dump file created
```

To analyse heap dumps there are a lot of tools out there including some inbuilt tools (jhat) as part of Java. if you wish to use 

# For jhat try:
>su - tomcat -c "jmap -dump:format=b,file=/var/tmp/a.data  {jvm PID}"

Otherwise you could use jvisualvm or even better eclipse Memory Analyzer (MAT)

If this is on a remote Linux machine and you are already on Linux Desktop :

```
ssh -X {hostname}

env|grep DISPLAY
DISPLAY=localhost:10.0

cp .Xauthority /tmp/MyAuthority

sudo -i
export XAUTHORITY="/tmp/MyAuthority

jvisualvm /var/tmp/a.data 
```

The above has used -X to pass on my display information, then the .Xauthority file was copied to temp folder, user changed to su, exported XAUTHORITY and launched jvisualvm


# Memory usage using verbose GC:
In tomcat Simply edit your setenv.sh and add something like this to your export JAVA_OPTS lines:

>-Djava.awt.headless=true -verbose:gc -Xloggc:/path/to/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps  

Restart tomcat, this wil now create gc.log in desired path and you could then use further shell scripts to work out when things go above a certain threshold, or if your code has a memory leak.




