#!/bin/bash

set -e

CONFDIR="/opt/lsfce/conf"

echo "$0: Set up lsfuser qrmi_config.json, examples, venv"
# qrmi_config.json for API keys
mkdir -p /home/lsfuser/.config
chmod 700 /home/lsfuser/.config
cp /distribution/qrmi_config.json.user /home/lsfuser/.config/qrmi_config.json
chmod 600 /home/lsfuser/.config/qrmi_config.json
# Examples
cp -r /distribution/examples /home/lsfuser
# venv
python3 -m venv /home/lsfuser/pyenv
source /home/lsfuser/pyenv/bin/activate
pip install --upgrade pip
pip install dotenv numpy requests qrmi numpy qiskit qiskit_ibm_runtime
chown -R lsfuser:lsfuser /home/lsfuser

echo "$0: Configure lsfadmin and lsfuser to source profile.lsf in .bashrc"
cat >> /home/lsfadmin/.bashrc <<EOF

# LSF
if [ -f /opt/lsfce/conf/profile.lsf ]; then . /opt/lsfce/conf/profile.lsf; fi
EOF

cat >> /home/lsfuser/.bashrc <<EOF

# LSF and MPICH
if [ -f /opt/lsfce/conf/profile.lsf ]; then . /opt/lsfce/conf/profile.lsf; fi
export PATH=/opt/mpich/bin:\$PATH
export LD_LIBRARY_PATH=/opt/mpich/lib:\$LD_LIBRARY_PATH
EOF
