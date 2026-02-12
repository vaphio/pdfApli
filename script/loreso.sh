#!/bin/bash
A=1
D=$1"low/"
E=".jpg"
TW=800

if [ -e $D ]; then
	rm -r $D
fi
#ls -a $1*.png > soc.txt
mkdir $D

while read line
do
	F=$line
	echo $F
	if [ $A -gt 99 ]
	then
		H="lo"
	elif [ $A -lt 10 ]
	then
		H="lo00"
	else
		H="lo0"
	fi
	T=$D$H$A$E
	echo $T
	convert -resize $TWx $F $T
	A=$(($A+1))
done < soc.txt
