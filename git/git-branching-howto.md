# Guide on how to clone and develop off a specific branch 
### Firstly I created a develop branch on github then I ran :


####git clone https://github.com/vahidhedayati/exttest.git


####cd exttest


####git remote show origin
```
* remote origin
  Fetch URL: https://github.com/vahidhedayati/exttest.git
  Push  URL: https://github.com/vahidhedayati/exttest.git
  HEAD branch (remote HEAD is ambiguous, may be one of the following):
    develop
    master
  Remote branches:
    develop tracked
    master  tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
```

####git remote update
Fetching origin


####git checkout -b release-1.2 origin/develop
```
Branch release-1.2 set up to track remote branch develop from origin.
Switched to a new branch 'release-1.2'
```

####vi application.properties 


####git commit -a -m "1.2 branch update"
```
[release-1.2 7db39fc] 1.2 branch update
 1 file changed, 1 insertion(+)
```

####git checkout develop
```
Branch develop set up to track remote branch develop from origin.
Switched to a new branch 'develop'
```


####git merge --no-ff release-1.2
```
Merge made by the 'recursive' strategy.
 application.properties |    1 +
 1 file changed, 1 insertion(+)
```


####git branch -d  release-1.2
```
warning: not deleting branch 'release-1.2' that is not yet merged to
         'refs/remotes/origin/develop', even though it is merged to HEAD.
error: The branch 'release-1.2' is not fully merged.
If you are sure you want to delete it, run 'git branch -D release-1.2'.
```

####git push origin develop
```
Username for 'https://github.com': XXXX
Password for 'https://XXXX@github.com': 
To https://github.com/vahidhedayati/exttest.git
   3634695..9bc915d  develop -> develop
```

####git branch -d  release-1.2
```
Deleted branch release-1.2 (was 7db39fc).
```
