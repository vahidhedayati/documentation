##Functions that can be added to your bashrc to make the job of exporting java / grails easier:
[Also check autocomplete_UPDATED](https://github.com/vahidhedayati/documentation/blob/master/grails/autocomplete_UPDATED.md) This contains the latest in all these aliases.

function jh {
        if [[ $1 =~ "/" ]]; then
                export JAVA_HOME=$1;
        else
           if [ "$1"  == "7" ] || [ "$1" == "" ];  then
              export JAVA_HOME=/usr/lib/jvm/jdk7
           elif  [ "$1"  == "8" ]; then
              export JAVA_HOME=/usr/lib/jvm/jdk8
          fi
      fi
}
export jh

function gv {
         grails_root="$HOME/grails3"
         if [[ $1 =~ "/" ]]; then
                export GRAILS_HOME=$1;
        else
          if [ "$1"  == "4" ] || [ "$1" == "" ];  then
                export GRAILS_HOME=$grails_root/grails-2.4.4
          elif  [ "$1"  == "3" ]; then
                export GRAILS_HOME=$grails_root/grails-3.0.1
                alias gradle=$grails_root/gradle-2.3/bin/gradle
          elif  [ "$1"  == "2" ]; then
                export GRAILS_HOME=$grails_root/grails-2.4.2
          fi
      fi

     alias grails=$GRAILS_HOME/bin/grails
     if env|grep -q JAVA_HOME; then
       echo -n
     else
       echo "Exporting JAVA_HOME"
       jh
    fi
}
export gv

function genggts {
        grails integrate-with --eclipse
}
export genggts



########## 
# Now to execute:
#  By default gv will load default grails (2.4.4) and java (1.7)..
# so run gv:
# gv
#### -> Exporting JAVA_HOME
# grails -version
#### -> Grails version: 2.4.4
# gv 2
# grails -version
#### -> Grails version: 2.4.2

## To change java home on the fly:

# jh 8
# env|grep JAVA_HOME
#### -> JAVA_HOME=/usr/lib/jvm/jdk1.8.0_11/
# jh 7 
# env|grep JAVA_HOME
#### -> JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

function ginst {
        gv 3 && rm -rf  ~/.m2/repository/org/grails/plugins/$1/* && cd ../$1 && grails clean && grails install && cd ../$2 && grails clean && grails run-app
}
#  grep -r config\.[a-z] *|grep -v "config.wschat"|awk -F"config." '{print "wchat."$2}'|awk -F" " '{print $1}'|egrep -v "wschat.$|roperty\)"|awk -F")" '{print $1}'

# cd src 
# (grep -r getConfig|awk -F"'" '{print "wschat."$2}' && grep -r config\.[a-z] *|grep -v "config.wschat"|awk -F"config." '{print "wschat."$2}'|awk -F" " '{print $1}'|egrep -v "wschat.$|roperty\)"|awk -F")" '{print $1}')  > ~/configitems.txt 
# cd ../grails
# (grep -r getConfig|awk -F"'" '{print "wschat."$2}' && grep -r config\.[a-z] *|grep -v "config.wschat"|awk -F"config." '{print "wschat."$2}'|awk -F" " '{print $1}'|egrep -v "wschat.$|roperty\)"|awk -F")" '{print $1}')  >> ~/configitems.txt 
