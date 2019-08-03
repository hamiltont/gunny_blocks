#!/bin/bash

FILE=${1:-combined.scad}

echo "Combining files into one mega-SCAD for thingiverse..."

rm -f $FILE

for i in `ls *.scad`
do 
   echo "// ------------ START: $i -----------------" >> $FILE
   # Remove include statements
   # Trim 100% of whitespace, as the customizer cannot handle whitespace before comments
   cat $i \
     | grep -v "include <" \
     | awk '{$1=$1;print}' >> $FILE
   echo "" >> $FILE
   echo "// ------------ END: $i -----------------" >> $FILE
done
