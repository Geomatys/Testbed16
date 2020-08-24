#!/bin/sh

arguments="$@";
command="papermill ";
parameters="";
index=0;
multi=0;
for arg in "$@"; do
    if [ $index -gt 1 ];
    then
        case ${arg} in
	    -S*) propName=$(echo $arg | cut -c 3-)
	         parameters=${parameters}${propName}':'
	         multi=0;;
	    -M*) propName=$(echo $arg | cut  -c 3-)
	         parameters=${parameters}${propName}':\n'
	         multi=1;;
	     *)  if [ $multi -eq 1 ];
    		 then 
    		 	parameters=${parameters}' - '${arg}'\n'
    		 else 
    		 	parameters=${parameters}' '${arg}'\n'
    		 fi
	esac
    else 
        command="${command} ${arg}"
    fi
    index=$((index+1))
done

echo "${parameters}"

echo "${parameters}" >> input.yml

$command -f input.yml
