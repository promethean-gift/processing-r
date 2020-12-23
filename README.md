# processing-r

r scripting for [lidR](https://github.com/Jean-Romain/lidR) processing USGS and USFS lidar datasets over the Jemez.

# container

If you have a CyVerse account, you can launch a container here:

<a href="https://de.cyverse.org/de/?type=quick-launch&quick-launch-id=e7383172-dafd-42a2-b539-a67a9b65425e&app-id=6943b4f2-b663-11ea-92c5-008cfa5ae621" target="_blank"><img src="https://de.cyverse.org/Powered-By-CyVerse-blue.svg"></a>  [![TAG](https://img.shields.io/docker/v/cyversevice/rstudio-geospatial/4.0.0)](https://microbadger.com/images/cyversevice/rstudio-geospatial:4.0.0) 

You can run the container locally with Docker:

```
docker run -it --rm -v /$HOME:/app --workdir /app -p 8787:80 -e REDIRECT_URL=http://localhost:8787 cyversevice/rstudio-geospatial:4.0.0
```

# steps

Clone this repository:

```
git clone https://github.com/promethean-gift/processing-r
```

Open the .RProj file in RStudio
