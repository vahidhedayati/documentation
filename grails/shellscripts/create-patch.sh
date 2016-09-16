#!/bin/bash
# used for GGTS/STS Eclipse patch files
# If you work with patches and have a situation where the current code has not been checked in 
# but then need to update something else maybe create another patch but face the situation that it's both in one 
# this script can help separate and generate a new patch for just that bit

# Before you can use this make a copy of the workspace with the last patch that had not been checked in 
# to backup/{projectName}

# Now with the new updates copy the updated project to new/{projectName}

# define the patch file name defined as file below (you could change this to input params)

existing="/cygdrive/c/workspace/backup/project"
new="/cygdrive/c/workspace/new/project"
file="/cygdrive/c/Users/me/latest-patch.patch"

## This goes into previous version code
cd  $existing
# runs a diff and generates a patch of difference of old/new in grails-app 
diff -Naur grails-app $new/grails-app > $file
# same for src folder
diff -Naur src $new/src >> $file


## the lates-patch.patch should now be like a patch that would be exported if the code base had been upto the point of existing
