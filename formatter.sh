#!/bin/bash


if [ $# -ne 2 ]
then
    echo "Usage: $0 <data.txt> <binary>"
    exit 1
fi

# check if the main binary is a valid binary file
if ! file "$2" | grep -q "ELF.*executable"; then
    echo "$2 is not a valid binary file"
    exit 1
fi

# check if the main binary has debugging symbols
if ! nm "$2" | grep -q " main$"; then
    echo "$2 does not have debugging symbols"
    exit 1
fi

# output tag
printf "%-18s %-18s %-18s %-18s %-18s %-18s\n" "callee" "caller" "arg1" "arg2" "arg3" "arg4"

# read data.txt line by line
cat $1 | while read line; do
    # echo "0x0000000000401ce4 0x0000000000401e0a" | awk '{print $1, $2}'                                   
    # 0x0000000000401ce4 0x0000000000401e0a

    # split each line to 6 column
    arr=($(echo $line | awk '{print $1, $2, $3, $4, $5, $6}'))

# TODO:
    func=$(addr2line -e $2 -f -s ${arr[0]} | sed -n '1p')
    prev_func=$(addr2line -e $2 -f -s ${arr[1]} | sed -n '1p')

    printf "%-18s %-18s %-18s %-18s %-18s %-18s\n" "$func" "$prev_func" "${arr[2]}" "${arr[3]}" "${arr[4]}" "${arr[5]}"
done
