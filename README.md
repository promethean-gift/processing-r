# processing-r

r scripting for [lidR](https://github.com/Jean-Romain/lidR) (re)processing USGS and USFS lidar, and sUAS Structure from Motoin (SfM) datasets over the Jemez Mountain study sites for their forest canopy and tree segmentation metrics.

# containers

Our analyses were run using Docker containers on NSF CyVerse and University of Arizona cyberinfrastructure.

If you have a CyVerse account, you can launch the container used in our analyses here:

<a href="https://de.cyverse.org/de/?type=quick-launch&quick-launch-id=12f25023-b6b1-4f23-bbcc-49f0295da8c4&app-id=07e2b2e6-becd-11e9-b524-008cfa5ae621" target="_blank"><img src="https://de.cyverse.org/Powered-By-CyVerse-blue.svg"></a> </a>  [![TAG](https://img.shields.io/docker/v/cyversevice/rstudio-geospatial/4.0.0)](https://microbadger.com/images/cyversevice/rstudio-geospatial:4.0.0) 

Alternately, you can run the container locally with [Docker](https://docker.com):

```
docker run -it --rm -v /$HOME:/app --workdir /app -p 8787:80 -e REDIRECT_URL=http://localhost:8787 cyversevice/rstudio-geospatial:4.0.0
```

# steps

Clone this repository in the RStudio console:

```
git clone https://github.com/promethean-gift/processing-r
```

Open the .RProj file in RStudio

Open the .r and .Rmd files

Follow the steps or modify the code in the `.r` or `.Rmd` files to change and to select new data sets.
