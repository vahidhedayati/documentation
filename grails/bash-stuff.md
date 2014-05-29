TO back up a project a nice easy alias is the following to tar up a folder

Add this to your .bashrc or where ever you have your aliases:

```bash
today=$(echo $(date +%-Y-%m-%d))
function tx { tar --exclude=".git" --exclude="target" -cvzf $1-$today.tar.gz $1; }
export tx
```


source this file or open a new session and try it out
```bash
tx foldername
```


I have run it all in one and showed the result as follows:
```bash
tx announcements 2>&1 > /dev/null && ls -rtml | tail -n 1
-rw-r--r--  1 vahid vahid 2.7M May 15 16:30 announcements-2014-05-15.tar.gz
```


Replace content
==============

replace content in multiple files:
```
grep -r "update: \"POST\", " *
xxx.groovy:	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
xxxx.groovy:	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
......
```


```
grep -r "update: \"POST\", " *|awk -F":" '{print "replace.sh \"update: \\\"POST\\\",\" \"\" " $1}'|/bin/sh
```

- for unique list:
```
grep -r "update: \"POST\", " *|awk -F":" '${print $1}'|sort|uniq|awk '{print "replace.sh \"update: \\\"POST\\\",\" \"\" " $0}'|/bin/sh
```

refer to https://github.com/vahidhedayati/replace_content for replace.sh
