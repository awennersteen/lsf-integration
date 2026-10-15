#!/bin/bash

set -e

echo "LSF_TAR=${LSF_TAR}"

if [ -z "${LSF_TAR}" ]; then
    echo "ERROR: LSF_TAR is not set"
    exit 1
fi

cd /distribution

# Extract CE package
tar --no-same-owner -xf "${LSF_TAR}"

LSF_DIR="${LSF_TAR%.tar.Z}"

# Select installer tar based on package type
case "${LSF_TAR}" in
    *armv8.tar.Z)
        INSTALLER_TAR="lsf10.1_no_jre_lsfinstall.tar.Z"
        INSTALLER_DIR="lsf10.1_lsfinstall"
        ;;
    *x86_64.tar.Z)
        INSTALLER_TAR="lsf10.1_lsfinstall_linux_x86_64.tar.Z"
        INSTALLER_DIR="lsf10.1_lsfinstall"
        ;;
    *)
    echo "Unsupported LSF package: ${LSF_TAR}"
        exit 1
        ;;
    esac

cd "${LSF_DIR}/lsf"
echo "Extracting ${INSTALLER_TAR}"
tar --no-same-owner -xf "${INSTALLER_TAR}"
cd "${INSTALLER_DIR}"
cat > install.config <<EOF
LSF_TOP="/opt/lsfce"
LSF_ADMINS="lsfadmin"
LSF_CLUSTER_NAME="cluster1"
LSF_MASTER_LIST="lsf-head compute01 compute02"
LSF_TARDIR="/distribution/${LSF_DIR}/lsf/"
EOF

echo 1 | ./lsfinstall -f install.config
