FROM ubuntu:jammy

RUN apt update
# install two helper packages we need
# update indices
# install two helper packages we need
RUN apt-get install -y --no-install-recommends software-properties-common dirmngr wget gpg-agent
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

RUN apt-get install -y \
    r-base \
    r-base-dev \
    r-cran-tidyverse \
    r-cran-furrr \ 
    r-cran-devtools \
    r-cran-rcurl \ 
    r-cran-purrr \
    r-cran-readr \
    r-cran-validate \
    r-cran-rvest \
    r-cran-httr2 \
    r-cran-jsonlite \
    r-cran-forcats \
    r-cran-janitor \
    r-cran-knitr \
    r-cran-openxlsx \
    r-cran-data.table \
    r-cran-htmlwidgets \
    r-cran-promises \
    r-cran-sourcetools \
    r-cran-xtable \
    r-cran-shiny \
    r-cran-profvis \
    r-cran-miniui \
    r-cran-httpuv \
    r-cran-later \
    r-cran-pkgdown \
    r-cran-fst \
    r-cran-fstcore
    
RUN chmod 777 /usr/local/lib/R/site-library

RUN Rscript -e 'install.packages("pacman")'
RUN Rscript -e 'pacman::p_load(aws.s3)'
RUN Rscript -e 'remotes::install_github("quartzsoftwarellc/quartz")'
RUN Rscript -e 'remotes::install_github("quartzsoftwarellc/shiny.quartz")'

RUN wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb
RUN apt install -y ./shiny-server-1.5.20.1002-amd64.deb
RUN apt install -y curl
# RUN apt install -y nginx

RUN apt install -y \
    r-cran-rgeoda \
    r-cran-sf \
    r-cran-tigris \
    r-cran-leaflet


RUN Rscript -e 'devtools::install_github("chris-prener/prener")'
RUN chmod -R 777 /srv/shiny-server

RUN Rscript -e 'remotes::install_github("quartzsoftwarellc/ggquartz")'

RUN apt-get install -y \
    r-cran-plotly

CMD ["shiny-server"]

