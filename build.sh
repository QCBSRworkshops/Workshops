mkdir public
cp README.md public

# get template
wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
unzip master


for i in $(seq 2)
do
  num=$(printf "%02d" $i)
  # files in folder
  fol=Workshop$num
  dirs=($fol/*/)
  for dir in "${dirs[@]}"
  do
    fil=${dir%*/}
    fil=${fil##*/}
    lang=${fil##*-}
    mkdir -p public/$fol/$lang
    echo $fil
    echo $fol
    cp -r -t public/$fol/$lang templateWorkshops-master/assets templateWorkshops-master/qcbs*
    cp -r -t public/$fol/$lang $fol/$fil/$fil.Rmd $fol/$fil/images
    #cp: illegal option -- t...?
    cd public/$fol/$lang && Rscript -e "rmarkdown::render('$fil.Rmd')" && cd ../../..
  done
done

rm -rf master.zip templateWorkshops-master
