#!/bin/bash

mkdir public
cp README.md public

# get template
wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
unzip master


for i in 1 2 3 4 6 7 8 10
do
  num=$(printf "%02d" $i)
  # files in folder
  wks=workshop$num
  for dir in $wks/*
  do
    lang=${dir##*-}
    mkdir -p public/$dir
    cp -r templateWorkshops-master/assets templateWorkshops-master/qcbs* public/$dir
    cp -r $dir/*.Rmd $dir/images $dir/*.csv $dir/Scripts_and_data public/$dir
    $dir/*.Rmd
    # #cp: illegal option -- t...?
    cd public/$dir && Rscript -e "rmarkdown::render('$wks-$lang.Rmd')" && cd ../../..
  done
done

rm -rf master.zip templateWorkshops-master
