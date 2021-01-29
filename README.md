[![Project Supported by CyVerse](https://img.shields.io/badge/Supported%20by-CyVerse-blue.svg)](https://learning.cyverse.org/projects/vice/en/latest/) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://opensource.org/licenses/GPL-3.0)

# processing-r

r scripting for [lidR](https://github.com/Jean-Romain/lidR) (re)processing USGS and USFS lidar, and sUAS Structure from Motoin (SfM) datasets over the Jemez Mountain study sites for their forest canopy and tree segmentation metrics.

# containers
[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/repository/docker/cyversevice/jupyterlab-geospatial)

Our analyses were run using Docker containers on NSF CyVerse and University of Arizona cyberinfrastructure.

After you create a [CyVerse Account](https://user.cyverse.org/) (free), you can launch the container used in our analyses here: <a href="https://de.cyverse.org/de/?type=quick-launch&quick-launch-id=12f25023-b6b1-4f23-bbcc-49f0295da8c4&app-id=07e2b2e6-becd-11e9-b524-008cfa5ae621" target="_blank"><img src="https://de.cyverse.org/Powered-By-CyVerse-blue.svg"></a> 

Alternately, you can install [Docker](https://docker.com) and run the analysis on your local computer:

```
docker run -it --rm -v /$HOME:/workspace --workdir /workspace -p 8787:80 -e REDIRECT_URL=http://localhost:8787 cyversevice/rstudio-geospatial:4.0.0
```

# steps

Clone this repository in the RStudio console:

```
git clone https://github.com/promethean-gift/processing-r
```

Open the .RProj file in RStudio

Open the .r and .Rmd files

Follow the steps or modify the code in the `.r` or `.Rmd` files to change and to select new data sets.
