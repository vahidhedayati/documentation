#!/bin/bash
##########################################
# genpatch.sh will generate an eclipse based patch for a grails based project grails 2(on eclipse / ggts / sts )
# ready to go and fit in from two destination folders
# currently generates a patch for Mercurial based SVNs
#
# The scenario you have your code base. You have maybe additional patches that are required 
# for this to work but those patches not checked in so in effect your current work exported
# as patch would also include those other patches.
#
# To generate a specific patch between the point of the other patches vs this content the steps are:
# step 1 : Export patch including your current work and all the other patches imported as part of it
# step 2 : Only Import the existing patches that this patch requires. 
# step 3: Copy the folder / or maybe entire base app folder with those patches to a new destination.
#       In this example all I needed as the grails-app folder
#  >> Now using tortoise or however it is clean up the code base back to how it was.

# step 4:  import step1  -- This should now include your latest changes and all the other patches.
# step 5: Now copy the entire app folder in this case the grails-app folder which now includes the latest changes into another folder.
#    I now have:
#     /tmp/makepatch/grails-app 
#     /tmp/makepatch/latest/grails-app
#    The first folder contains step 3 copied folder 
#    The 2nd folder within makepatch called latest contains grails-app from step5
# genpatch.sh --grailsapp /tmp/makepatch/ /tmp/makepatch/latest/ -o /path/to/mypatch.patch
# genpatch.sh --grailsapp --src --verbose --jscss --ddl /tmp/makepatch/grails-app /tmp/makepatch/latest/grails-app -o /path/to/mypatch.patch
# genpatch.sh --gsjd /tmp/makepatch/grails-app /tmp/makepatch/latest/grails-app -o /path/to/mypatch.patch
# When defining the above options you are telling this script which folders to make a patch out of between those two folders in my case
# I copied just grails-app folder so if I do as above
# genpatch.sh --grailsapp /tmp/makepatch/grails-app /tmp/makepatch/latest/grails-app -o /path/to/mypatch.patch
# it tells script to find grails-app in the given folder and make a patch which forks perfectly since i know that is only changes 
# if it was all over the other segments then copy entire folder and include which bits to check
##########################################

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
	echo "I’m sorry, `getopt --test` failed in this environment."
	echo "$0 -gsjd/path/to/currentCodeBase /path/to/latestCodeFolder -o /path/to/newPatch.patch"
	exit 1
fi

SHORT=gsjdo:v
LONG=grailsapp,src,jscss,ddl,output:,verbose
PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
eval set -- "$PARSED"
# myscript -gsjd /path/to/currentCodeBase /path/to/latestCodeFolder -o /path/to/newPatch.patch
while true; do
    case "$1" in
        -g|--grailsapp)
            g=y
            shift
            ;;
        -s|--src)
            f=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -j|--jscss)
            j=y
            shift
            ;;
        -d|--ddl)
            d=y
            shift
            ;;
        -o|--output)
            outFile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 2 ]]; then
	echo "$0 --grailsapp /tmp/makepatch/ /tmp/makepatch/latest/ -o /path/to/mypatch.patch"
	echo "$0  --grailsapp --src --verbose --jscss --ddl /tmp/makepatch/ /tmp/makepatch/latest/ -o /path/to/mypatch.patch"
	echo "$0  --g /tmp/makepatch/grails-app /tmp/makepatch/latest/grails-app -o /path/to/mypatch.patch"
	echo "$0  --gsjd /tmp/makepatch/ /tmp/makepatch/latest/ -o /path/to/mypatch.patch"
	echo "When defining the above options you are telling this script which folders to make a patch out of between those two folders"
    exit 4
fi

echo "include grails-app: $g, incluse src: $s, include js / css: $j, verbose: $v include ddl: $d ( orig: $1, latest: $2  ) -> out: $outFile";

function replace() {
  echo "working on $in1"
  in=$in1 out=$out1 perl -pi -e 's/\Q$ENV{"in"}/$ENV{"out"}/g' $outFile;
}
function checkFolder() {
	if [[ $v == "y" ]]; then
		echo "Checking $pwd/$folder vs $new/$folder";
	fi
	diff -Naur $folder $new/$folder >> $outFile;
}

revisionKey="93a8b78266db"

new=$2;
cd $1;
>$outFile;

if [[ $g == "y" ]]; then
	folder="grails-app";
	checkFolder;
fi
if [[ $s == "y" ]]; then
	folder="src";
	checkFolder;
fi
if [[ $d == "y" ]]; then
	folder="scripts/DDL_Latest.txt";
	checkFolder;
fi
if [[ $j == "y" ]]; then
	folder="web-app/css";
	checkFolder;
	folder="web-app/js";
	checkFolder;
fi
in1="diff -Naur";
out1="diff -r $revisionKey";
replace;
if [[ $v == "y" ]]; then
	echo "replaced diff -Naur with $revisionKey"
fi

in1="$new"
out1="";
replace;
if [[ $v == "y" ]]; then
	echo "replaced $in1 with $out1"
fi
in1="--- "
out1="--- a/";
replace;
if [[ $v == "y" ]]; then
	echo "replaced $in1 with $out1"
fi
in1="+++ /"
out1="+++ b/";
replace;
if [[ $v == "y" ]]; then
	echo "replaced $in1 with $out1"
fi
