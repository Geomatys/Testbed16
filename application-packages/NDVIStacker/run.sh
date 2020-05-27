#!/bin/sh

arguments="$@";
command="papermill ";
parameters="args:  \n";
index=0;

for arg in "$@"; do
    if [ $index -gt 1 ];
    then
    	parameters="${parameters} - ${arg}\n"
    else 
        command="${command} ${arg}"
    fi
    index=$((index+1))
done

echo ${parameters}

echo ${parameters} >> input.yml

$command -f input.yml
