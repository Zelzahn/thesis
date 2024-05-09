#!/bin/bash

for file in $(ls *.svg);
do
    inkscape -w 1024 $file  -o ${file%.svg}.png 
done
