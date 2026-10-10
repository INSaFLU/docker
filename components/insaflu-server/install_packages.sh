#!/bin/bash
# components/insaflu-server/install_packages.sh
# Points yum at vault.centos.org and installs the system packages every later
# step builds against. This is its own script so the tool build stages can
# start FROM the image it produces.

set -e

sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

echo "Install package dependencies"
yum -y install epel-release

packages=(
    gdal
    gdal-devel
    dos2unix
    parallel
    postgis
    postgresql-devel
    postgresql
    httpd
    httpd-tools
    httpd-devel
    mod_wsgi
    bash
    file
    binutils
    gzip
    git
    unzip
    wget
    java
    perl
    perl-devel
    perl-Time-Piece
    perl-XML-Simple
    perl-Digest-MD5
    perl-CPAN
    perl-Module-Build
    perl-File-Slurp
    "perl-Test*"
    python38
    python38-pip
    python3-devel
    gcc
    zlib-devel
    bzip2-devel
    xz-devel
    python38-devel
    cmake
    cmake3
    gcc-c++
    autoconf
    bzip2
    automake
    libtool
    libjpeg-turbo-devel
    lapack-devel
    blas-devel
    suitesparse-devel
    which
    https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-1.x86_64.rpm
)

yum -y install "${packages[@]}"
