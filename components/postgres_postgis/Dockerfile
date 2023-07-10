FROM postgres:10.23-bullseye
MAINTAINER Mike Dillon <mike@appropriate.io>

#ENV POSTGIS_MAJOR 2.4
## if you get an error check for the last version in https://www.ubuntuupdates.org/package/postgresql/trusty-pgdg/main/base/postgresql-10-postgis-2.4-scripts
# ENV POSTGIS_VERSION 2.4.4+dfsg-4.pgdg18.04+1
ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.2.3+dfsg-1.pgdg110+1

RUN apt-get update \
      && apt install -y --no-install-recommends \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      postgis \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./update-postgis.sh /usr/local/bin


