

Ctrl + Alt + O (Code → Optimize Imports...) 

Build compile ...appname/pluginname..


ls -rtml ~/grails

```
total 8.0K
drwxr-xr-x  7 vahid vahid 4.0K Feb 26 16:25 grails-3.0.0.M2
drwxr-xr-x 11 vahid vahid 4.0K Mar  4 13:17 grails-2.4.4
```



ls -rtml ~/grails3/
```
total 347M
drwxr-xr-x 6 vahid vahid 4.0K Feb 16 06:16 gradle-2.3
-rw-rw-r-- 1 vahid vahid 132M Mar  4 09:24 grails-3.0.0.M2.zip
-rw-rw-r-- 1 vahid vahid 175M Mar  4 13:19 ideaIC-14.0.3.tar.gz
-rw-rw-r-- 1 vahid vahid  41M Mar  4 13:22 gradle-2.3-bin.zip
```


.bashrc
```

function jh {
	if [[ $1 =~ "/" ]]; then
		export JAVA_HOME=$1;
	else

		if [ "$1"  == "7" ] || [ "$1" == "" ];  then
			export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
		elif  [ "$1"  == "8" ]; then
			#export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_11/
			 export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_31/

		fi
	fi
	
	alias java=$JAVA_HOME/bin/java
}
export jh

function gv {

	 grails_root="/home/vahid/grails/"

	 if [[ $1 =~ "/" ]]; then
                export GRAILS_HOME=$1;
        else
		 if [ "$1"  == "4" ] || [ "$1" == "" ];  then
			export GRAILS_HOME=$grails_root/grails-2.4.4
		elif  [ "$1"  == "37" ]; then
			export GRAILS_HOME=$grails_root/grails-2.3.7
		elif  [ "$1"  == "3" ]; then
			export GRAILS_HOME=$grails_root/grails-3.0.0.M2
			alias gradle=/home/vahid/grails3/gradle-2.3/bin/gradle
		elif  [ "$1"  == "2" ]; then
			export GRAILS_HOME=$grails_root/grails-2.4.2
                fi

	fi

	alias grails=$GRAILS_HOME/bin/grails
	if env|grep -q JAVA_HOME; then
		#	echo "JAVA_SET"
		echo -n 
	else
		echo "Exporting JAVA_HOME"
		jh
	fi

}
export gv

```


now run gv 3 followed by jh 7 

this should allow grails3 to work with java 7 
