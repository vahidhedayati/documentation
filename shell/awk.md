Awk goodies
=======================


Pattern matching 

>tail -f /var/log/httpd/access_log|awk -v  pass="191.[0-9]" '{if ($1 ~ pass) print $0 "bad"}'

The awk statement above has a variable of pass looking for 191.[0-9] 191.{patternmatch 0-9} then if the first column contains this variable print the line $0 plus add bad at the end of each line

>191.1xx.2xx.6xx - - [xx/xx/xx:10:30:59 +0100] ......


grabs out return codes beginning 50
>awk '$9 ~ 50' $file

grabs out return codes beginning 40 or 50
>awk '$9 ~ 50,40' $file

grep ^123 = grabs out return codes beginning 40 or 50 with IP addr beginning 123
>awk '$9 ~ 50,40' $file |grep ^123


simple way to extract from and to time in apahce log (between 01:00 and 02:00
>awk -F ':' '{print$2$3" "$0}' /var/log/httpd/access_log | awk '$1>=from&&$1<=to' from="0100" to="0200"


awk pattern search
>awk '/start_pattern/,/end_pattern/' $file

Passing variables to search pattern - typically its awk -v variable=value, this does not work and this nasty hack was used
>echo "$cat $FILE|awk '/ $STIME:00/,/ $FTIME:00/'"|/bin/sh >  $TFILE 


# Awk decimal calculations:
```
percentage=$(echo $xtot|awk -v tot=$tot '{$3 = $1 / 'tot'; print $3}')
final=$(echo $percentage|awk '{$3 = $1 * 100; print $3}')
```
Maths
```
echo "25066.55" |awk '{ $3 = $1 / 3; print $1, $3 }'
25066.55 8355.52
```


Extracting first values of seperated list
```
foo="ABC_BBC_1"
echo $foo|awk -F"_" 'BEGIN {p1="";p2="";p3="";}  { p1=substr($1,0,1); p2=substr($2,0,1); p3=substr($3,0,1);} END { print p1""p2""p3 }' 
```

produces:
>AB1
