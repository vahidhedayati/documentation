### Auto complete grails variants from your bash command line. For Linux and OSX.

[How to Video](https://www.youtube.com/watch?v=W2QHsmgicek)

###Requirements in your home folder 
```
mkdir grails3
```

then put gradle grails-2.4.4 grails-2.4.5 grails-3.0.1 in that folder, if you are using different versions to those then update the bashrc gv calls below to relevant versions anf prefered calls i.e. 4 5 3 etc



### auto complete file for grails run this on your shell

```
sudo bash
cat <<< '
g4_commands="-debug-fork -verbose -plain-output -refresh-dependencies -reloading -stacktrace -offline -version -non-interactive dev create-app add-proxy alias bootstrap bug-report clean clean-all clear-proxy compile console create-app create-controller create-domain-class create-filters create-integration-test create-multi-project-build create-plugin create-pom create-script create-service create-tag-lib create-unit-test dependency-report doc help init install-app-templates install-dependency install-plugin install-templates integrate-with interactive list-plugin-updates list-plugins migrate-docs package package-plugin plugin-info refresh-dependencies remove-proxy run-app run-script run-war set-grails-version set-proxy set-version shell stats stop-app test-app uninstall-plugin url-mappings-report war wrapper"

g3_commands="create-app create-app bug-report clean compile console create-controller create-domain-class create-functional-test create-integration-test create-interceptor create-script create-service create-taglib create-unit-test dependency-report generate-all generate-controller gradle help install install-templates list-plugins open package plugin-info run-app schema-export shell stats test-app url-mappings-report war"


have grails &&
_grails()
{
      local cur=${COMP_WORDS[COMP_CWORD]}
	if [[ $GRAILS_AC == "g4" ]]; then
      		COMPREPLY=($(compgen -W "`echo $g4_commands `" -- $cur))
	elif [[ $GRAILS_AC == "g3" ]]; then
      		COMPREPLY=($(compgen -W "`echo $g3_commands `" -- $cur))
	fi
      command="${COMP_WORDS[1]}"
}
[ "${have:-}" ] && complete -F _grails -o default grails
'> /etc/bash_completion.d/grails

```

### bashrc updates run below in your shell:
```
cat <<< '
function jh {
        if [[ $1 =~ "/" ]]; then
                export JAVA_HOME=$1;
        else
                if [ "$1"  == "7" ] || [ "$1" == "" ];  then
                        export JAVA_HOME=/usr/lib/jvm/jdk7/
                elif  [ "$1"  == "8" ]; then
                        export JAVA_HOME=/usr/lib/jvm/jdk8/
                fi
        fi
}
export jh

function gv {
         grails_root="$HOME/grails3/"
         if [[ $1 =~ "/" ]]; then
                export GRAILS_HOME=$1;
        else
                 if [ "$1"  == "4" ] || [ "$1" == "" ];  then
			thisVersion="2.4.4"
			export GRAILS_AC="g4"
                        function g4 () {
                                $GRAILS_HOME/bin/grails  "$@";
                        }
                        #alias grails=g4
                 elif [ "$1"  == "5" ];   then
			thisVersion="2.4.5"
			# for all 2 variants the GRAILS_AC is g4
			export GRAILS_AC="g4"
                        function g4 () {
                                $GRAILS_HOME/bin/grails  "$@";
                        }
                elif  [ "$1"  == "3" ]; then
			thisVersion="3.0.1"
			# for all grails 3 variants if you has 3.0.2 as another block this would be g3
			export GRAILS_AC="g3"
                        alias gradle=$grails_root/gradle-2.3/bin/gradle
                        function g3 () {
                                $GRAILS_HOME/bin/grails  "$@";
                        }
                        #alias grails=g3
                elif  [ "$1"  == "2" ]; then
                        thisVersion="2.4.2"
                fi
		export GRAILS_VERSION=$thisVersion
                export GRAILS_HOME=$grails_root/grails-$thisVersion
		alias grails=$GRAILS_HOME/bin/grails

        fi
        if env|grep -q JAVA_HOME; then
                #       echo "JAVA_SET"
                echo -n
        else
                echo "Exporting JAVA_HOME"
                jh
        fi

}
export gv

function setup_gv() {
	if id|grep -q root; then 
		echo "setting up your system"; go="true;" 
		# create grails on your machine
		setupFile grails
		setupFile g3
		setupFile g4
	else  
		echo "need to run this as root so sudo bash and when root run setup_gv";  
	fi
}

alias sudo="sudo "

function setupFile {
	if which $1 |grep -q $1; then  echo "found $1 ignoring";  else echo "spoofing command /usr/local/bin/$1 on your system" && touch /usr/local/bin/$1 && chmod 755 /usr/local/bin/$1; fi
}

function genggts {
        grails integrate-with --eclipse
}
export genggts

today=$(echo $(date +%-Y-%m-%d))
function tx { tar --exclude=".git" --exclude="target" -cvzf $1-$today.tar.gz $1; }
export tx
'>> ~/.bashrc
```

All done, now open a new shell  or 
```
. ~/.bashrc
sudo bash
setup_gv
exit
gv 4
## this will export out grails 2.4.4 and give auto complete for grails 2, simply type in grails and press tab tab 
gv 3
## this will export out grails 3.0.1 and give auto complete for grails 3, simply type in grails and press tab tab 
```

so here is it running on my machine:

```
mx1@mx1-DTP:~/test3$ gv 3
mx1@mx1-DTP:~/test3$ grails 
bug-report               console                  create-domain-class      create-interceptor       create-taglib            generate-all             help                     list-plugins             plugin-info              shell                    url-mappings-report      
clean                    create-app               create-functional-test   create-script            create-unit-test         generate-controller      install                  open                     run-app                  stats                    war                      
compile                  create-controller        create-integration-test  create-service           dependency-report        gradle                   install-templates        package                  schema-export            test-app                 
mx1@mx1-DTP:~/test3$ grails ^C
```

````
mx1@mx1-DTP:~/test3$ gv 4
mx1@mx1-DTP:~/test3$ grails 
add-proxy                   clear-proxy                 create-filters              create-service              doc                         install-templates           -non-interactive            -refresh-dependencies       run-war                     stats                       -version
alias                       compile                     create-integration-test     create-tag-lib              help                        integrate-with              -offline                    refresh-dependencies        set-grails-version          stop-app                    war
bootstrap                   console                     create-multi-project-build  create-unit-test            init                        interactive                 package                     -reloading                  set-proxy                   test-app                    wrapper
bug-report                  create-app                  create-plugin               -debug-fork                 install-app-templates       list-plugins                package-plugin              remove-proxy                set-version                 uninstall-plugin            
clean                       create-controller           create-pom                  dependency-report           install-dependency          list-plugin-updates         -plain-output               run-app                     shell                       url-mappings-report         
clean-all                   create-domain-class         create-script               dev                         install-plugin              migrate-docs                plugin-info                 run-script                  -stacktrace                 -verbose                    
mx1@mx1-DTP:~/test3$ grails 


````
