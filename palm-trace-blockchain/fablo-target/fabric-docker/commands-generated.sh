#!/usr/bin/env bash

generateArtifacts() {
  printHeadline "Generating basic configs" "U1F913"

  printItalics "Generating crypto material for PalmTraceOrderer" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-palmtraceorderer.yaml" "peerOrganizations/orderer.palmtrace.co.id" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for Petani" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-petani.yaml" "peerOrganizations/petani.palmtrace.co.id" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for Koperasi" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-koperasi.yaml" "peerOrganizations/koperasi.palmtrace.co.id" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for PabrikKelapaSawit" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-pabrikkelapasawit.yaml" "peerOrganizations/pabrikkelapasawit.palmtrace.co.id" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for Unilever" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-unilever.yaml" "peerOrganizations/unilever.palmtrace.co.id" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating genesis block for group palmtrace-orderer-group" "U1F3E0"
  genesisBlockCreate "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config" "Palmtrace-orderer-groupGenesis"

  # Create directory for chaincode packages to avoid permission errors on linux
  mkdir -p "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"
}

startNetwork() {
  printHeadline "Starting network" "U1F680"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose up -d)
  sleep 4
}

generateChannelsArtifacts() {
  printHeadline "Generating config for 'rantai-pasok-channel'" "U1F913"
  createChannelTx "rantai-pasok-channel" "$FABLO_NETWORK_ROOT/fabric-config" "RantaiPasokChannel" "$FABLO_NETWORK_ROOT/fabric-config/config"
}

installChannels() {
  printHeadline "Creating 'rantai-pasok-channel' on Petani/peer0" "U1F63B"
  docker exec -i cli.petani.palmtrace.co.id bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'rantai-pasok-channel' 'PetaniMSP' 'peer0.petani.palmtrace.co.id:7041' 'crypto/users/Admin@petani.palmtrace.co.id/msp' 'orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030';"

  printItalics "Joining 'rantai-pasok-channel' on  Koperasi/peer0" "U1F638"
  docker exec -i cli.koperasi.palmtrace.co.id bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'rantai-pasok-channel' 'KoperasiMSP' 'peer0.koperasi.palmtrace.co.id:7061' 'crypto/users/Admin@koperasi.palmtrace.co.id/msp' 'orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030';"
  printItalics "Joining 'rantai-pasok-channel' on  PabrikKelapaSawit/peer0" "U1F638"
  docker exec -i cli.pabrikkelapasawit.palmtrace.co.id bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'rantai-pasok-channel' 'PabrikKelapaSawitMSP' 'peer0.pabrikkelapasawit.palmtrace.co.id:7081' 'crypto/users/Admin@pabrikkelapasawit.palmtrace.co.id/msp' 'orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030';"
  printItalics "Joining 'rantai-pasok-channel' on  Unilever/peer0" "U1F638"
  docker exec -i cli.unilever.palmtrace.co.id bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'rantai-pasok-channel' 'UnileverMSP' 'peer0.unilever.palmtrace.co.id:7101' 'crypto/users/Admin@unilever.palmtrace.co.id/msp' 'orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030';"
}

installChaincodes() {
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'rantai-pasok-chaincode'" "U1F60E"
    chaincodeBuild "rantai-pasok-chaincode" "golang" "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode" "16"
    chaincodePackage "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" "golang" printHeadline "Installing 'rantai-pasok-chaincode' for Petani" "U1F60E"
    chaincodeInstall "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" ""
    chaincodeApprove "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Installing 'rantai-pasok-chaincode' for Koperasi" "U1F60E"
    chaincodeInstall "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-chaincode" "$version" ""
    chaincodeApprove "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Installing 'rantai-pasok-chaincode' for PabrikKelapaSawit" "U1F60E"
    chaincodeInstall "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-chaincode" "$version" ""
    chaincodeApprove "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Installing 'rantai-pasok-chaincode' for Unilever" "U1F60E"
    chaincodeInstall "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-chaincode" "$version" ""
    chaincodeApprove "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printItalics "Committing chaincode 'rantai-pasok-chaincode' on channel 'rantai-pasok-channel' as 'Petani'" "U1F618"
    chaincodeCommit "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" "peer0.petani.palmtrace.co.id:7041,peer0.koperasi.palmtrace.co.id:7061,peer0.pabrikkelapasawit.palmtrace.co.id:7081,peer0.unilever.palmtrace.co.id:7101" "" ""
  else
    echo "Warning! Skipping chaincode 'rantai-pasok-chaincode' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode'"
  fi

}

installChaincode() {
  local chaincodeName="$1"
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  local version="$2"
  if [ -z "$version" ]; then
    echo "Error: chaincode version is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "rantai-pasok-chaincode" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode")" ]; then
      printHeadline "Packaging chaincode 'rantai-pasok-chaincode'" "U1F60E"
      chaincodeBuild "rantai-pasok-chaincode" "golang" "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode" "16"
      chaincodePackage "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" "golang" printHeadline "Installing 'rantai-pasok-chaincode' for Petani" "U1F60E"
      chaincodeInstall "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for Koperasi" "U1F60E"
      chaincodeInstall "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for PabrikKelapaSawit" "U1F60E"
      chaincodeInstall "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for Unilever" "U1F60E"
      chaincodeInstall "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printItalics "Committing chaincode 'rantai-pasok-chaincode' on channel 'rantai-pasok-channel' as 'Petani'" "U1F618"
      chaincodeCommit "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" "peer0.petani.palmtrace.co.id:7041,peer0.koperasi.palmtrace.co.id:7061,peer0.pabrikkelapasawit.palmtrace.co.id:7081,peer0.unilever.palmtrace.co.id:7101" "" ""

    else
      echo "Warning! Skipping chaincode 'rantai-pasok-chaincode' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode'"
    fi
  fi
}

runDevModeChaincode() {
  local chaincodeName=$1
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "rantai-pasok-chaincode" ]; then
    local version="0.0.1"
    printHeadline "Approving 'rantai-pasok-chaincode' for Petani (dev mode)" "U1F60E"
    chaincodeApprove "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "0.0.1" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Approving 'rantai-pasok-chaincode' for Koperasi (dev mode)" "U1F60E"
    chaincodeApprove "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-channel" "rantai-pasok-chaincode" "0.0.1" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Approving 'rantai-pasok-chaincode' for PabrikKelapaSawit (dev mode)" "U1F60E"
    chaincodeApprove "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-channel" "rantai-pasok-chaincode" "0.0.1" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printHeadline "Approving 'rantai-pasok-chaincode' for Unilever (dev mode)" "U1F60E"
    chaincodeApprove "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-channel" "rantai-pasok-chaincode" "0.0.1" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
    printItalics "Committing chaincode 'rantai-pasok-chaincode' on channel 'rantai-pasok-channel' as 'Petani' (dev mode)" "U1F618"
    chaincodeCommit "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "0.0.1" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" "peer0.petani.palmtrace.co.id:7041,peer0.koperasi.palmtrace.co.id:7061,peer0.pabrikkelapasawit.palmtrace.co.id:7081,peer0.unilever.palmtrace.co.id:7101" "" ""

  fi
}

upgradeChaincode() {
  local chaincodeName="$1"
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  local version="$2"
  if [ -z "$version" ]; then
    echo "Error: chaincode version is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "rantai-pasok-chaincode" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode")" ]; then
      printHeadline "Packaging chaincode 'rantai-pasok-chaincode'" "U1F60E"
      chaincodeBuild "rantai-pasok-chaincode" "golang" "$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode" "16"
      chaincodePackage "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" "golang" printHeadline "Installing 'rantai-pasok-chaincode' for Petani" "U1F60E"
      chaincodeInstall "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for Koperasi" "U1F60E"
      chaincodeInstall "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for PabrikKelapaSawit" "U1F60E"
      chaincodeInstall "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printHeadline "Installing 'rantai-pasok-chaincode' for Unilever" "U1F60E"
      chaincodeInstall "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-chaincode" "$version" ""
      chaincodeApprove "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" ""
      printItalics "Committing chaincode 'rantai-pasok-chaincode' on channel 'rantai-pasok-channel' as 'Petani'" "U1F618"
      chaincodeCommit "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041" "rantai-pasok-channel" "rantai-pasok-chaincode" "$version" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030" "" "false" "" "peer0.petani.palmtrace.co.id:7041,peer0.koperasi.palmtrace.co.id:7061,peer0.pabrikkelapasawit.palmtrace.co.id:7081,peer0.unilever.palmtrace.co.id:7101" "" ""

    else
      echo "Warning! Skipping chaincode 'rantai-pasok-chaincode' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/rantai-pasok-chaincode'"
    fi
  fi
}

notifyOrgsAboutChannels() {
  printHeadline "Creating new channel config blocks" "U1F537"
  createNewChannelUpdateTx "rantai-pasok-channel" "PetaniMSP" "RantaiPasokChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "rantai-pasok-channel" "KoperasiMSP" "RantaiPasokChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "rantai-pasok-channel" "PabrikKelapaSawitMSP" "RantaiPasokChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "rantai-pasok-channel" "UnileverMSP" "RantaiPasokChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"

  printHeadline "Notyfing orgs about channels" "U1F4E2"
  notifyOrgAboutNewChannel "rantai-pasok-channel" "PetaniMSP" "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030"
  notifyOrgAboutNewChannel "rantai-pasok-channel" "KoperasiMSP" "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030"
  notifyOrgAboutNewChannel "rantai-pasok-channel" "PabrikKelapaSawitMSP" "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030"
  notifyOrgAboutNewChannel "rantai-pasok-channel" "UnileverMSP" "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id" "orderer0.palmtrace-orderer-group.orderer.palmtrace.co.id:7030"

  printHeadline "Deleting new channel config blocks" "U1F52A"
  deleteNewChannelUpdateTx "rantai-pasok-channel" "PetaniMSP" "cli.petani.palmtrace.co.id"
  deleteNewChannelUpdateTx "rantai-pasok-channel" "KoperasiMSP" "cli.koperasi.palmtrace.co.id"
  deleteNewChannelUpdateTx "rantai-pasok-channel" "PabrikKelapaSawitMSP" "cli.pabrikkelapasawit.palmtrace.co.id"
  deleteNewChannelUpdateTx "rantai-pasok-channel" "UnileverMSP" "cli.unilever.palmtrace.co.id"
}

printStartSuccessInfo() {
  printHeadline "Done! Enjoy your fresh network" "U1F984"
}

stopNetwork() {
  printHeadline "Stopping network" "U1F68F"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose stop)
  sleep 4
}

networkDown() {
  printHeadline "Destroying network" "U1F916"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose down)

  printf "\nRemoving chaincode containers & images... \U1F5D1 \n"
  for container in $(docker ps -a | grep "dev-peer0.petani.palmtrace.co.id-rantai-pasok-chaincode" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.petani.palmtrace.co.id-rantai-pasok-chaincode*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.koperasi.palmtrace.co.id-rantai-pasok-chaincode" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.koperasi.palmtrace.co.id-rantai-pasok-chaincode*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.pabrikkelapasawit.palmtrace.co.id-rantai-pasok-chaincode" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.pabrikkelapasawit.palmtrace.co.id-rantai-pasok-chaincode*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.unilever.palmtrace.co.id-rantai-pasok-chaincode" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.unilever.palmtrace.co.id-rantai-pasok-chaincode*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done

  printf "\nRemoving generated configs... \U1F5D1 \n"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/crypto-config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"

  printHeadline "Done! Network was purged" "U1F5D1"
}
