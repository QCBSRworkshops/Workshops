#!/bin/bash

# get template
wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
unzip master


for i in  1 2 4 #$(seq 4)
do
  num=$(printf "%02d" $i)
  # files in folder
  wks=workshop$num
  for dir in $wks/*
  do
    lang=${dir##*-}
    cp -r templateWorkshops-master/assets templateWorkshops-master/qcbs* $dir
  done
done

rm -rf master.zip templateWorkshops-master
