#!/bin/bash

mkdir public
cp README.md public

# get template
wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip -O public/master.zip
unzip public/master.zip -d public && rm -f public/master.zip

for i in $(seq 10)
do
  wks=workshop$(printf "%02d" $i)
  mkdir -p public/$wks
  for dir in $wks/*
  do
    lang=${dir##*-}
    echo $wks
    echo $dir
    cp -r $dir/ public/$dir
    cd public/$dir && Rscript --no-init-file -e "rmarkdown::render('$wks-$lang.Rmd')" && cd ../../..
  done
done
