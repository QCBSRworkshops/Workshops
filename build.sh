mkdir -p public/en public/fr
echo "[French](fr/Aterlier01.html)" > public/index.md
echo "[English](en/Workshop01.html)" >> public/index.md

wget https://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
unzip master

cp -r -t public/fr Atelier01/Atelier01_Slides.Rmd Atelier01/images
cp -r -t public/en Workshop01/Workshop01_Slides.Rmd Workshop01/images

for i in "en" "fr"
do
  cp -r -t public/$i templateWorkshops-master/assets templateWorkshops-master/qcbs*
done

rm -rf master.zip templateWorkshops-master


cd public/fr && Rscript -e "rmarkdown::render('Atelier01_Slides.Rmd')" && cd ../..
cd public/en && Rscript -e "rmarkdown::render('Workshop01_Slides.Rmd')" && cd ../..
