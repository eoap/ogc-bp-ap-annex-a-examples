FROM osgeo/gdal

RUN apt update && \
    apt-get install -y jq

ADD functions.sh /functions.sh

ADD crop /usr/bin/crop

RUN chmod +x /usr/bin/crop
