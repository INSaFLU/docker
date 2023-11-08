
set -e

cd /software
apt-get  -y install libffi-devel
## sudo apt install libffi-dev
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
tar -xf Python-3.7.4.tgz
cd Python-3.7.4
./configure --enable-optimizations
make -j 8
make altinstall
## release space
cd ..
rm -rf Python-3.7.4*
## python3.7 --version

## pangolin virtual env
virtualenv pangolin --python=python3.7 --prompt "(pangolin) "
. pangolin/bin/activate
pip3 install biopython==1.74 pandas==1.0.1 snakemake pysam
cd pangolin
pip3 install git+https://github.com/cov-lineages/pangolin.git
pip3 install git+https://github.com/cov-lineages/scorpio.git
pip3 install git+https://github.com/cov-lineages/constellations.git
pip3 install git+https://github.com/cov-lineages/pango-designation.git
pip3 install git+https://github.com/cov-lineages/pangolin-data.git
pip3 install git+https://github.com/cov-lineages/pangoLEARN.git --upgrade

## external software
mkdir minimap2; cd minimap2
wget https://github.com/lh3/minimap2/releases/download/v2.18/minimap2-2.18_x64-linux.tar.bz2
tar -jxvf minimap2-2.18_x64-linux.tar.bz2; rm minimap2-2.18_x64-linux.tar.bz2
cd ..; mkdir gofasta; cd gofasta
wget https://github.com/cov-ert/gofasta/releases/download/v0.0.3/gofasta-linux-amd64
chmod a+x gofasta-linux-amd64

## faToVCF
cd ..; mkdir faToVcf; cd faToVcf
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faToVcf
chmod a+x faToVcf

## make links
cd ../bin
ln -s ../minimap2/minimap2-2.18_x64-linux/minimap2 minimap2
ln -s ../minimap2/minimap2-2.18_x64-linux/k8 k8
ln -s ../gofasta/gofasta-linux-amd64 gofasta
ln -s ../faToVcf/faToVcf .

### is not going to use usher, only to trap it
touch /software/pangolin/bin/usher
chmod a+x /software/pangolin/bin/usher
## done
