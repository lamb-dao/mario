#!/bin/bash

# This script is not complete
# Objective: create any directory structure from a text representation
# where tabs indicate nesting level


#make call from data
#set variables
        path=$0
        name=$(basename -s .sh ${path})
	#USER set target directory. Default create directory in data
	target=$(pwd)

<<SKIP
BEGIN

#<CALL>
I_dir
	i_dir
		a_file.type
		b_file.type
		c_file.type
	ii_dir
		a_file.type
II_dir
        i_dir
		a_file.type
        ii_dir
III_dir
IIII_dir
	a_file.type
	b_file.type
a_file.type
b_file.type
#<SETTINGS>

END
SKIP

printf "\nBeginning: ${path}"

        #print everything between <CALL> <SETTINGS> to main log
        settings=$(cat $path | sed -n '/^ *#<CALL> *$/,/^ *#<SETTINGS> *$/p')
        printf "\n$settings" >> ../logfile_${pipeName}

#strip ends, remove lines which describe files, leaving folders
list=$(echo "$settings" | grep -v '<*>'| grep -Fv '.')

#create rootNode path at runtime
fullPath=${target}/${pipeName}

#...rename old or delete and overwrite
#tests if outputfile/filename<anymatch> is pre existing
        #no
            #write file tree
        #yes
            #tests if overwrite
                #no
                    #write file tree
                #yes
                    #delete file recursively
                    #write file tree

#create folder string, using brace expansion
#this mechanisim is a preorder traversal with the root node at 'fullPath'
    folderStr=${fullPath}
    down="/{<>}"
    folderStr=${folderStr}${down}

    #searches folderStr for first "<>" and replaces with first arg, 'down' to descend, null to ascend
    function xcend{
        inStr=$1

        #ascend, if argument is null
        if [[ inStr == "" ]]
            #find and remove first ",<>"
            then folderStr=$(sed 's/,<>//' folderStr)
        #descend, if argument is 'down'
        elif [[ inStr == "/{<>}" ]]
            #insert 'down'before "<>"
            then folderStr=$)sed 's/<>/\/{<>}<>/' folderStr)
        #any other case, append
        else
            #replace <> with 'inStr'
            folderStr=$(sed "s/<>/${inStr}/" folderStr)
        fi
    }

    function append{
        app=$1
        app="${app},<>"
        xsend app
    }

    function Delta{
        #count tabs for 2 lines
        t1=
            #remove top line
        t2=
        #Delta = tab#ln2 - tab#ln1
        A=t2-t1
        #return Delta
	return $A

    }

    function top{
        sed '1d' list
    }
    #for each line in list append to folderString
    A=Delta
    topLine=top
    #tabDelta(tA)\= (line n+1 tab#)-(line n tab#)  eg. 1-0 = +1 therefore indent one level
        #if tA=0 then continue at same level
        #tA is +ve or -ve
            #next line +ve x then descend x levels
            #next line -ve x then ascend x levels

#create a directory and set permissions: userRWXgroupRWXworld---
mkdir -p -m770 ${folderStr}



#write all files
    #get a list of files to create
    #for each file in list



