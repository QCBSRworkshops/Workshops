copy_css:
	sh copy.sh

pres:
	sh build.sh

template:
		wget Rschttps://github.com/QCBSRworkshops/templateWorkshops/archive/master.zip
		unzip master
		rm -rf master.zip templateWorkshops-master

clean:
	rm -rf public

readme:
	Rscript -e "rmarkdown::render('README.Rmd')"
