

grep js ApplicationResources.groovy |awk -F":" '{print $2}'|sed -e "s/'//g"|sed -e "s/^ //g"|awk '{print "<asset:javascript src=\""$0"\"/>"}'

grep css ApplicationResources.groovy |awk -F":" '{print $2}'|sed -e "s/'//g"|sed -e "s/^ //g"|awk '{print "<asset:stylesheet src=\""$0"\"/>"}'
