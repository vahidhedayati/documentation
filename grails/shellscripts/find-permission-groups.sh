#!/bin/bash

# Written by Vahid Hedayati
# will attempt to find all the permission groups set in 
# used against apache shiro should work with spring security
# Grails 2 since SecurityFilters again shiro based

workspace="/cygdrive/c/workspace/projectName"
securityFilter="$workspace/grails-app/conf/SecurityFilters.groovy"
views="$workspace/grails-app/views"
mcontrollers="$workspace/grails-app/controllers"
messages="$workspace/grails-app/i18n/messages.properties"


codes="PERM-GROUP1 PERM-GROUP2"
echo -e "PERMISSION,GSP,MASTER_GSP,MASTER_CONTROLLER,GSPGROUP,CONTROLLER,CONTROLLER ACTIONS,CALLING CONTROLLER, CALLING ACTION,PERMITTED\r"
function parseFile() {
         while read -r line; do
                        if [[ $line =~ "$cjsf" ]]; then
                                go=1
                        fi

                        if [[ $go == 1 ]] ; then
                                if [[ $line =~ "}\nfunction" ]]; then
                                        go=0
                                fi
                                if [[ $go == 1 ]]; then
                                         if [[ $line =~ "controller:" ]]; then
                                                cac=$(echo $line|awk -F"controller:'" '{print $2}'|awk -F"'" '{print $1}')
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi

                                                cact=$(echo $line|awk -F"action:'" '{print $2}'|awk -F"'" '{print $1}')
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"

                                        elif [[ $line =~ "controller=" ]]; then
                                                cac=$(echo $line|awk -F"controller=\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                cact=$(echo $line|awk -F"action=\"" '{print $2}'|awk -F"\"" '{print $1}')

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"

                                        elif [[ $line =~ "createLink(" ]]; then
                                                cac=$(echo $line|awk -F"controller: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:'" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                cact=$(echo $line|awk -F"action: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                         cact=$(echo $line|awk -F"action:'" '{print $2}'|awk -F"'" '{print $1}')
                                                fi

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"
                                        fi

                                fi
                        fi
         done < "$views/"$file".gsp"
}

for code in $codes; do
        cd $views;
        #files=$(grep -r $code *|awk -F":" '{print $1}'|sort|uniq)
        files2=$(grep -r $code *|awk -F":" '{print $1}'|sort|uniq|awk -F".gsp" '{print $1}')
        cd $mcontrollers;
        controllerText=''
        currentController=''
        masterFile=''
        masterController=''
        for file in $(echo -e $files2); do
                controllerText=''
                currentController=''

                fileView=$(echo $file|tr -d "_")
                fcount=$(grep -r $file *|awk -F":" '{print $1}'|wc -l)
                fcont=$(grep -r $file *|awk -F":" '{print $1}'|sort|uniq)
                if [[ $fcount -gt 0 ]]; then
                        currentController=$(echo ${fcont##*/}|sed -e "s:.groovy::"|sed -e s":Controller::")
                        for fc in $fcont; do
                                lines=$(grep -n "$fileView"  $fc|awk -F":" '{print $1}')
                                lastN=0
                                for ln in $lines; do
                                        if [[ $lastN -gt 0 ]]; then
                                                byLine=`expr $ln - $lastN`
                                                controllerText="$controllerText | $(head -n$ln $fc|grep -B$byLine $fileView |grep "def .* {"|tail -n 1|awk -F"def " '{print $2}'|awk -F"(" '{print $1}') "
                                        else
                                                controllerText="$controllerText | $(head -n$ln $fc|grep -B$ln $fileView |grep "def .* {"|tail -n 1|awk -F"def " '{print $2}'|awk -F"(" '{print $1}') "
                                        fi
                                        lastN=$ln
                                done
                        done
                else
                         currenController=''
                         controllerText=''
                                ntemplate=$(echo $file|tr -d "_")
                                #filepath=$(echo ${file%/*})
                                masterFiles=$(grep -r $ntemplate $views/*|grep template|awk -F":" '{print $1}'|sort|uniq|awk -F"views/" '{print $2}')
                                ##masterFile=$(echo -n $masterFile)
                                #cd $mcontrollers;
                                masterFile=''
                                for cfile in $masterFiles; do
                                        if [[ $masterFile == "" ]]; then
                                                masterFile=$cfile
                                        else
                                                masterFile=$masterFile"|"$cfile
                                        fi
                                #       masterController=$masterController"|"$(grep $cfile *|awk -F":" '{print $1}'|sort|uniq|sed -e "s:Controller.groovy::g")
                                done



                fi
                permGroup=$(grep -A1 shiro:hasPermission "$views/"$file".gsp"|grep -A1 $code|grep g:set|awk -F"var=\"" '{print $2}'|awk -F"\""  '{print $1}')
                if [[ $permGroup == "" ]]; then

                        echo -e "$code,$file,$masterFile,$masterController,,$currentController,$controllerText,,,$actions\r"

                else
                        while read -r line; do
                        if [[ $line =~ "g:if test=" ]] && [[  $line =~ "$permGroup" ]]; then
                                go=1
                                counter=0
                        fi

                        if [[ $go == 1 ]] && [[ counter -lt 4 ]]; then
                                ((counter++))
                                if [[ $line =~ "\<\/g:if" ]]; then
                                        go=0
                                fi
                                if [[ $go == 1 ]]; then
                                        if [[ $line =~  "code=" ]]; then
                                                message=$(echo $line|awk -F"code=\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                #if [[ $message =~ ".label" ]]; then
                                                        actions=$(grep $message $messages|awk -F"=" '{print $2}'|head -n1)

                                                        echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,,,$actions\r"

                                                #fi
                                        elif [[ $line =~ "controller:" ]]; then
                                                cac=$(echo $line|awk -F"controller:'" '{print $2}'|awk -F"'" '{print $1}')
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi

                                                cact=$(echo $line|awk -F"action:'" '{print $2}'|awk -F"'" '{print $1}')
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"

                                        elif [[ $line =~ "controller=" ]]; then
                                                cac=$(echo $line|awk -F"controller=\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                cact=$(echo $line|awk -F"action=\"" '{print $2}'|awk -F"\"" '{print $1}')

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"

                                        elif [[ $line =~ "createLink(" ]]; then
                                                cac=$(echo $line|awk -F"controller: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller:'" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cac == "" ]]; then
                                                        cac=$(echo $line|awk -F"controller: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                cact=$(echo $line|awk -F"action: \"" '{print $2}'|awk -F"\"" '{print $1}')
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action:\"" '{print $2}'|awk -F"\"" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                        cact=$(echo $line|awk -F"action: '" '{print $2}'|awk -F"'" '{print $1}')
                                                fi
                                                if [[ $cact == "" ]]; then
                                                         cact=$(echo $line|awk -F"action:'" '{print $2}'|awk -F"'" '{print $1}')
                                                fi

                                                echo -e "$code,$file,$masterFile,$masterController,$permGroup,$currentController,$controllerText,$cac,$cact,,\r"

                                        elif [[  $line =~ "function(){" ]]; then
                                                cjsf=$(echo $line|awk -F"function" '{print $2}'|awk -F"{" '{print $2}'|awk -F"}" '{print "function "$1}'|awk -F"(" '{print $1}')
                                                parseFile;

                                        fi


                                fi
                        fi

                        done < "$views/"$file".gsp"
                fi

        done

done
