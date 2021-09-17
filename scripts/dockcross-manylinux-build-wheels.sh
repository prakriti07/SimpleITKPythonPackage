#!/bin/bash

# Pull dockcross manylinux images
#docker pull dockcross/manylinux-x64
#docker pull dockcross/manylinux-x86

# Generate dockcross scripts
#docker run dockcross/manylinux-x64 > /tmp/dockcross-manylinux-x64 && chmod u+x /tmp/dockcross-manylinux-x64
#docker run dockcross/manylinux-x86 > /tmp/dockcross-manylinux-x86 && chmod u+x /tmp/dockcross-manylinux-x86

script_dir="`cd $(dirname $0); pwd`"

# Build wheels
pushd $script_dir/..
mkdir -p dist
DOCKER_ARGS="-v $(pwd)/dist:/work/dist/"
#/tmp/dockcross-manylinux-x64 -a "$DOCKER_ARGS" ./scripts/internal/manylinux-build-wheels.sh
#/tmp/dockcross-manylinux-x86 -a "$DOCKER_ARGS" ./scripts/internal/manylinux-build-wheels.sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker run --rm -v "$(pwd)"/dist:/work/dist/ -v "$(pwd)":/work:rw --workdir=/work quay.io/pypa/manylinux2014_aarch64 \
  bash -exc 'yum -y install vim-filesystem emacs-filesystem wget && \
  wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/n/ninja-build-1.7.2-2.el7.aarch64.rpm && \
  rpm -i ninja-build-1.7.2-2.el7.aarch64.rpm && \
  ln -s /usr/bin/ninja-build /usr/local/bin/ninja && \
  rm ninja-build-1.7.2-2.el7.aarch64.rpm && \
  ./scripts/internal/manylinux-build-wheels.sh'
popd
