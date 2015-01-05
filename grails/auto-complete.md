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
