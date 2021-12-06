#!/bin/bash

options=()
arguments=()
renames=()
is_sign_in=false
is_argument_in=false
errors=()
is_error=false

if [[ "$@" =~ "--" ]]
then
    is_sign_in=true
fi

while [ ! -z $1 ]
do
    if [[ "$is_sign_in" == true && "$is_arguments_in" == false ]]
    then
	if [[ $1 == "--" ]]
	then
	    is_arguments_in=true
	else
	    if [[ "$1" != "-d" && "$1" != "-v" && "$1" != "-h" ]]
	    then
		errors=("options")
		is_error=true
	    fi
	    if [[ ! "${options[*]}" =~ $1 ]]
	    then 
		options=("${options[@]}" "$1")
	    fi
	fi
    else
	if [[ "$1" == "-h" || "$1" == "-d" || "$1" == "-v" ]] && [[ "$is_sign_in" == false ]]
	then
	    if [[ ! "${options[*]}" =~ $1 ]]
	    then
		options=("${options[@]}" "$1")
	    fi
	else
	    arguments=("${arguments[@]}" "$1")
	fi
    fi
    shift
done



#Help
if [[ "${options[*]}" =~ "-h" && $is_error == false ]]
then
    echo "You can change the suffixs of the file. You can enter in the command line the command which is writen down and after that
put the suffixs you want to and the file name on which all of these is gonna be executed."
    echo "Options: -h(help), -d(change name)"
else
    if [[ "${#arguments[@]}" -le 1 ]]
    then
	is_error=true
	errors=("${errors[@]}" "arguments")
    fi
    if [[ $is_error == true ]]
    then
	for ((e=0; e<${#errors[@]}; e++))
	do
	    case "${errors[@]}"
	     in "options")
		echo "You have typed a wrong option"
	    "argument")
		echo "There are no arguments to execute the script"
		;;
	    esac
	done
	exit 2
    elif [[ $is_error == false ]]
    then
	#Other processes
	suffix="${arguments[0]}"
	argument=("${argument[@]:1}")

	#Creat new file name
	for i in "${argument[@]}"
	do
	    before="${i%.*}"
	    after="${i#$before}"
	    renames=("${renames[@]}" "$before$suffix$after")
	done

	#for -d process

	if [[ "${options[*]}" =~ "-d" && ! "${options[*]}" =~ "-v" ]]
	then
	    echo "Original name - New name"
#           m=0
#           while [[ $m -lt ${#arguments} ]]
#		One way of writing this loop
            for ((j=0; j<${#arguments}; ++j)) 
	    do
		echo "${arguments[$j]} - ${renames[$j]}"
#		((m++)) 
	    done
	#checking files in directories
	else
	    count=$((-1))
	    for k in "${argument[@]}"
	    do
		count=$((count + 1))
		if [[ -f "$k" ]]
		then
		    mv -- "$k" "${renames[$count]}"
		else
		    echo "The file '${k}' does not exist"
		    continue
		fi
		
		if [[ "${options[@]}" =~ "-v" ]]
		then
		    echo "${arguments[$count]} - ${renames[$count]}"
		fi
	    done
	fi
    fi
fi
exit 0







