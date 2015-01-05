##Functions that can be added to your bashrc to make the job of exporting java / grails easier:



function jh {
        if [[ $1 =~ "/" ]]; then
                export JAVA_HOME=$1;
        else

                if [ "$1"  == "7" ] || [ "$1" == "" ];  then
                        export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
                elif  [ "$1"  == "8" ]; then
                        export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_11/
                fi
        fi


}
export jh

function gv {

         grails_root="/home/vahid/grails/"

         if [[ $1 =~ "/" ]]; then
                export GRAILS_HOME=$1;
        else
                 if [ "$1"  == "4" ] || [ "$1" == "" ];  then
                        export GRAILS_HOME=$grails_root/grails-2.4.4
                elif  [ "$1"  == "3" ]; then
                        export GRAILS_HOME=$grails_root/grails-2.4.3
                elif  [ "$1"  == "2" ]; then
                        export GRAILS_HOME=$grails_root/grails-2.4.2
                fi

        fi

        alias grails=$GRAILS_HOME/bin/grails
        if env|grep -q JAVA_HOME; then
                #       echo "JAVA_SET"
                echo -n
        else
                echo "Exporting JAVA_HOME"
                jh
        fi

}
export gv



########## 
# Now to execute:
#  By default gv will load default grails (2.4.4) and java (1.7)..
# so run gv:
# gv
Exporting JAVA_HOME
# grails -version
Grails version: 2.4.4
# gv 2
# grails -version
Grails version: 2.4.2

## To change java home on the fly:

# jh 8
# env|grep JAVA_HOME
JAVA_HOME=/usr/lib/jvm/jdk1.8.0_11/
# jh 7 
# env|grep JAVA_HOME
JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

