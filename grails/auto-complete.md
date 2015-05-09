###New documentation according to video: 

[Can be seen](https://www.youtube.com/watch?v=RXSHApst2cc)

Creating/fooling your system g3 and g4 commands
```bash
sudo bash
touch /usr/bin/g3
touch /usr/bin/g4
chown $USER:$USER  /usr/bin/g3
chown $USER:$USER  /usr/bin/g4
```

creating the autocomplete files:
```bash
cat <<< '
g4_commands="-debug-fork -verbose -plain-output -refresh-dependencies -reloading -stacktrace -offline -version -non-interactive dev create-app add-proxy alias bootstrap bug-report clean clean-all clear-proxy compile console create-app create-controller create-domain-class create-filters create-integration-test create-multi-project-build create-plugin create-pom create-script create-service create-tag-lib create-unit-test dependency-report doc help init install-app-templates install-dependency install-plugin install-templates integrate-with interactive list-plugin-updates list-plugins migrate-docs package package-plugin plugin-info refresh-dependencies remove-proxy run-app run-script run-war set-grails-version set-proxy set-version shell stats stop-app test-app uninstall-plugin url-mappings-report war wrapper"

have g4 &&
_g4()
{
      local cur=${COMP_WORDS[COMP_CWORD]}
      COMPREPLY=($(compgen -W "`echo $g4_commands`" -- $cur))
      command="${COMP_WORDS[1]}"
}
[ "${have:-}" ] && complete -F _g4 -o default g4
'> /etc/bash_completion.d/g4


cat <<< '
g3_commands="create-app create-app bug-report clean compile console create-controller create-domain-class create-functional-test create-integration-test create-interceptor create-script create-service create-taglib create-unit-test dependency-report generate-all generate-controller gradle help install install-templates list-plugins open package plugin-info run-app schema-export shell stats test-app url-mappings-report war"


have g3 &&
_g3()
{
       local cur=${COMP_WORDS[COMP_CWORD]}
       COMPREPLY=($(compgen -W "`echo $g3_commands`" -- $cur))
       command="${COMP_WORDS[1]}"
}
[ "${have:-}" ] && complete -F _g3 -o default g3
'> /etc/bash_completion.d/g3
```

Creating .bashrc aliases/functions:
```bash
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
                        export GRAILS_HOME=$grails_root/grails-2.4.4
                        function g4 () {
                                $GRAILS_HOME/bin/grails  "$@";
                        }
                        alias grails=g4
                elif  [ "$1"  == "3" ]; then
                        export GRAILS_HOME=$grails_root/grails-3.0.1
                        alias gradle=$grails_root/gradle-2.3/bin/gradle
                        function g3 () {
                                $GRAILS_HOME/bin/grails  "$@";
                        }
                        alias grails=g3
                elif  [ "$1"  == "2" ]; then
                        export GRAILS_HOME=$grails_root/grails-2.4.2
                fi

        fi
        #alias grails=$GRAILS_HOME/bin/grails
        if env|grep -q JAVA_HOME; then
                #       echo "JAVA_SET"
                echo -n
        else
                echo "Exporting JAVA_HOME"
                jh
        fi

}
export gv
```


Now on a new shell:

```bash

mx1@mx1-DTP:~$ gv 4
mx1@mx1-DTP:~$ grails -version
Grails version: 2.4.4
mx1@mx1-DTP:~$ g4 -version 
Grails version: 2.4.4
mx1@mx1-DTP:~$ g4 
add-proxy                   create-app                  create-service              install-app-templates       -non-interactive            remove-proxy                stats
alias                       create-controller           create-tag-lib              install-dependency          -offline                    run-app                     stop-app
bootstrap                   create-domain-class         create-unit-test            install-plugin              package                     run-script                  test-app
bug-report                  create-filters              -debug-fork                 install-templates           package-plugin              run-war                     uninstall-plugin
clean                       create-integration-test     dependency-report           integrate-with              -plain-output               set-grails-version          url-mappings-report
clean-all                   create-multi-project-build  dev                         interactive                 plugin-info                 set-proxy                   -verbose
clear-proxy                 create-plugin               doc                         list-plugins                -refresh-dependencies       set-version                 -version
compile                     create-pom                  help                        list-plugin-updates         refresh-dependencies        shell                       war
console                     create-script               init                        migrate-docs                -reloading                  -stacktrace                 wrapper






mx1@mx1-DTP:~$ gv 3
| Grails Version: 3.0.1
| Groovy Version: 2.4.3
| JVM Version: 1.7.0_79
mx1@mx1-DTP:~$ g3 
bug-report               create-app               create-integration-test  create-taglib            generate-controller      install-templates        plugin-info              stats
clean                    create-controller        create-interceptor       create-unit-test         gradle                   list-plugins             run-app                  test-app
compile                  create-domain-class      create-script            dependency-report        help                     open                     schema-export            url-mappings-report
console                  create-functional-test   create-service           generate-all             install                  package                  shell                    war
mx1@mx1-DTP:~$ g3 

```





###Old grails 2 documentation

In order to add auto complete to grails command line: 

Try the following:

vi /etc/bash_completion.d/grails 


```bash

# -*- shell-script -*-
#
# Bash tab auto-completion rules for grails
# File: Name: grails Location: /etc/bash_completion.d/grails
# ensure this file is placed and stored as :  /etc/bash_completion.d/grails

grails_commands="-debug-fork -verbose -plain-output -refresh-dependencies -reloading -stacktrace -offline -version -non-interactive dev create-app add-proxy alias bootstrap bug-report clean clean-all clear-proxy compile console create-app create-controller create-domain-class create-filters create-integration-test create-multi-project-build create-plugin create-pom create-script create-service create-tag-lib create-unit-test dependency-report doc help init install-app-templates install-dependency install-plugin install-templates integrate-with interactive list-plugin-updates list-plugins migrate-docs package package-plugin plugin-info refresh-dependencies remove-proxy run-app run-script run-war set-grails-version set-proxy set-version shell stats stop-app test-app uninstall-plugin url-mappings-report war wrapper"

have grails &&
_grails()
{
        local cur=${COMP_WORDS[COMP_CWORD]}
       ##COMPREPLY=($(compgen -W "`grails help  2>&1 |grep ^grails|awk '{if ($2 ~ /^[a-z]/) { print $2}}'|tr '\n' ' '`" -- $cur))
       COMPREPLY=($(compgen -W "`echo $grails_commands`" -- $cur))

         command="${COMP_WORDS[1]}"
        #case "${command}" in
#create-app)
#       COMPREPLY=( $(compgen -W "`echo $pwd`" -- ${cur}) ); compopt -o nospace; return 0;;

#*) ;;
#esac


}
[ "${have:-}" ] && complete -F _grails -o default grails

```



Thats it !


now open a new session and from here on grails tab  tab 
```
> grails 
add-proxy                   console                     create-pom                  doc                         interactive                 -plain-output               run-war                     test-app
alias                       create-app                  create-script               help                        list-plugins                plugin-info                 set-grails-version          uninstall-plugin
bootstrap                   create-controller           create-service              init                        list-plugin-updates         -refresh-dependencies       set-proxy                   url-mappings-report
bug-report                  create-domain-class         create-tag-lib              install-app-templates       migrate-docs                refresh-dependencies        set-version                 -verbose
clean                       create-filters              create-unit-test            install-dependency          -non-interactive            -reloading                  shell                       -version
clean-all                   create-integration-test     -debug-fork                 install-plugin              -offline                    remove-proxy                -stacktrace                 war
clear-proxy                 create-multi-project-build  dependency-report           install-templates           package                     run-app                     stats                       wrapper
compile                     create-plugin               dev                         integrate-with              package-plugin              run-script                  stop-app              
```


grails c tab tab 
```
grails c
clean                       compile                     create-controller           create-integration-test     create-pom                  create-tag-lib              
clean-all                   console                     create-domain-class         create-multi-project-build  create-script               create-unit-test            
clear-proxy                 create-app                  create-filters              create-plugin               create-service              

```
