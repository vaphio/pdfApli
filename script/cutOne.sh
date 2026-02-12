#! /bin/bash
A=1
E=".jpg"
D=$1"cut/"
OW=2880
OH=1800
TW=1270
TW=$2
TH=1800
SIZE=$TW\x$TH
L0=$(((OW-TW)/2))
L2=$(((OW-TW*2)/2))
L1=$((OW/2))
T0=$((OH-TH))

if [ -e $D ]
then
    rm -r $D
fi

mkdir $D
ls -a $1*.png > soc.txt

while read line
do
	F=$line
	echo $F

	if [ $A -gt 99 ]
	then
		H="h"
	elif [ $A -lt 10 ]
	then
		H="h00"
	else
		H="h0"
	fi
	T=$D$H$A$E
	echo $T
	convert $F -crop $SIZE+$L0+$T0 $T

	A=$((A+1))
done < soc.txt
