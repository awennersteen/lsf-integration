#!/bin/bash

set -e

cd /tmp

# Build/install MPICH
wget -q https://www.mpich.org/static/downloads/4.2.3/mpich-4.2.3.tar.gz || echo "Download failed"
tar xzf mpich-4.2.3.tar.gz
cd mpich-4.2.3
./configure --disable-fortran --prefix=/opt/mpich
make -j 6
make install

# Configure environment for all users
cat > /etc/profile.d/mpich.sh <<EOF
export PATH=/opt/mpich/bin:\$PATH
export LD_LIBRARY_PATH=/opt/mpich/lib:\$LD_LIBRARY_PATH
EOF

chmod 644 /etc/profile.d/mpich.sh
