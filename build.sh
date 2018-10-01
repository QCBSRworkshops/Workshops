mkdir public
cp README.md public

# get template
wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
unzip master

for i in $(seq 1)
do
  num=$(printf "%02d" $i)
  for j in "en" "fr"
  do
    fol=workshop$num
    fil=$fol-$j
    mkdir -p public/$fol/$j
    echo $fil
    echo $fol
    cp -r -t public/$fol/$j templateWorkshops-master/assets templateWorkshops-master/qcbs*
    cp -r -t public/$fol/$j $fol/$fol-$j/$fol-$j.Rmd $fol/$fol-$j/images
    cd public/$fol/$j && Rscript -e "rmarkdown::render('$fol-$j.Rmd')" && cd ../../..
  done
done

rm -rf master.zip templateWorkshops-master
