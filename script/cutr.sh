#! /bin/bash
# cut png file 2pictures and save jpg file
# this cutr.sh is for right side open
# cut jpg file will be stored /cutr folder
# need 2 arguments for setting width default is 1270

A=1
E=".jpg"
D=$1"cutr/"
OW=2880
OH=1800
TW=1270
TW=$2
TH=1800
SIZE=$TW\x$TH
L0=$(((OW-TW)/2))
L1=$(((OW-TW*2)/2))
L2=$((OW/2))
#T0=$((OH-TH))
T0=0

if [ -e $D ]; then
	echo 'As '$D' already exists, it will be delated.'
	rm -r $D
fi
mkdir $D
ls -a $1*.png > soc.txt

while read line
do
	F=$line
	echo $F
	if [ $A -eq 1 ]
		then
		H="h00"
		T=$D$H$A$E
		echo $T
		convert $F -crop $SIZE+$L0+$T0 $T
	else
    B=$((A+1000))
    H="h"${B:1}
	T=$D$H$E
	echo $T
	convert $F -crop $SIZE+$L1+$T0 $T
	A=$((A+1))
    B=$((A+1000))
    H="h"${B:1}
	T=$D$H$E
	echo $T
	convert $F -crop $SIZE+$L2+$T0 $T

	fi
	A=$((A+1))
done < soc.txt
