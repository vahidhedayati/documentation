
##### Whilst attempting to update my git repo, I accidentally added this hprof file which github refused to publish due to file size, to fix the issue the following command was run:


```
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch java_pid19613.hprof'

```


##### To clone a specific branch :

```
git clone -b grails3 https://github.com/vahidhedayati/RemoteSSH.git


```

##### To move / make a new branch master:

```
git clone  https://github.com/vahidhedayati/RemoteSSH.git
cd RemoteSSH
git checkout grails3
git branch -m master old-master
git branch -m grails3 master
git push -f origin master

```

What above has done is checked out master branch then checked out the other branch in need.
moved master to old-master
moved new branch grails3 as master
and force pushed it back to master 
