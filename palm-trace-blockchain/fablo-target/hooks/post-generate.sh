#!/usr/bin/env bash

# The code from this file was called after Fablo generated Hyperledger Fabric configuration
echo "Executing post-generate hook"

perl -i -pe 's/MaxMessageCount: 10/MaxMessageCount: 1/g' "./fablo-target/fabric-config/configtx.yaml"
perl -i -pe 's/_VERSION=2.4.3/_VERSION=latest/g' ./fablo-target/fabric-docker/.env
perl -i -pe 's/FABRIC_CA_VERSION=1.5.0/FABRIC_CA_VERSION=latest/g' ./fablo-target/fabric-docker/.env
