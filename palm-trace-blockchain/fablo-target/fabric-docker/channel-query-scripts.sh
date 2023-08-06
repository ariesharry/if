#!/usr/bin/env bash

source "$FABLO_NETWORK_ROOT/fabric-docker/scripts/channel-query-functions.sh"

set -eu

channelQuery() {
  echo "-> Channel query: " + "$@"

  if [ "$#" -eq 1 ]; then
    printChannelsHelp

  elif [ "$1" = "list" ] && [ "$2" = "petani" ] && [ "$3" = "peer0" ]; then

    peerChannelList "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041"

  elif
    [ "$1" = "list" ] && [ "$2" = "koperasi" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061"

  elif
    [ "$1" = "list" ] && [ "$2" = "pabrikkelapasawit" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081"

  elif
    [ "$1" = "list" ] && [ "$2" = "unilever" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101"

  elif

    [ "$1" = "getinfo" ] && [ "$2" = "rantai-pasok-channel" ] && [ "$3" = "petani" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "rantai-pasok-channel" "cli.petani.palmtrace.co.id" "peer0.petani.palmtrace.co.id:7041"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "petani" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "rantai-pasok-channel" "cli.petani.palmtrace.co.id" "$TARGET_FILE" "peer0.petani.palmtrace.co.id:7041"

  elif [ "$1" = "fetch" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "petani" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "rantai-pasok-channel" "cli.petani.palmtrace.co.id" "${BLOCK_NAME}" "peer0.petani.palmtrace.co.id:7041" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "rantai-pasok-channel" ] && [ "$3" = "koperasi" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "rantai-pasok-channel" "cli.koperasi.palmtrace.co.id" "peer0.koperasi.palmtrace.co.id:7061"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "koperasi" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "rantai-pasok-channel" "cli.koperasi.palmtrace.co.id" "$TARGET_FILE" "peer0.koperasi.palmtrace.co.id:7061"

  elif [ "$1" = "fetch" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "koperasi" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "rantai-pasok-channel" "cli.koperasi.palmtrace.co.id" "${BLOCK_NAME}" "peer0.koperasi.palmtrace.co.id:7061" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "rantai-pasok-channel" ] && [ "$3" = "pabrikkelapasawit" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "rantai-pasok-channel" "cli.pabrikkelapasawit.palmtrace.co.id" "peer0.pabrikkelapasawit.palmtrace.co.id:7081"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "pabrikkelapasawit" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "rantai-pasok-channel" "cli.pabrikkelapasawit.palmtrace.co.id" "$TARGET_FILE" "peer0.pabrikkelapasawit.palmtrace.co.id:7081"

  elif [ "$1" = "fetch" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "pabrikkelapasawit" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "rantai-pasok-channel" "cli.pabrikkelapasawit.palmtrace.co.id" "${BLOCK_NAME}" "peer0.pabrikkelapasawit.palmtrace.co.id:7081" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "rantai-pasok-channel" ] && [ "$3" = "unilever" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "rantai-pasok-channel" "cli.unilever.palmtrace.co.id" "peer0.unilever.palmtrace.co.id:7101"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "unilever" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "rantai-pasok-channel" "cli.unilever.palmtrace.co.id" "$TARGET_FILE" "peer0.unilever.palmtrace.co.id:7101"

  elif [ "$1" = "fetch" ] && [ "$3" = "rantai-pasok-channel" ] && [ "$4" = "unilever" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "rantai-pasok-channel" "cli.unilever.palmtrace.co.id" "${BLOCK_NAME}" "peer0.unilever.palmtrace.co.id:7101" "$TARGET_FILE"

  else

    echo "$@"
    echo "$1, $2, $3, $4, $5, $6, $7, $#"
    printChannelsHelp
  fi

}

printChannelsHelp() {
  echo "Channel management commands:"
  echo ""

  echo "fablo channel list petani peer0"
  echo -e "\t List channels on 'peer0' of 'Petani'".
  echo ""

  echo "fablo channel list koperasi peer0"
  echo -e "\t List channels on 'peer0' of 'Koperasi'".
  echo ""

  echo "fablo channel list pabrikkelapasawit peer0"
  echo -e "\t List channels on 'peer0' of 'PabrikKelapaSawit'".
  echo ""

  echo "fablo channel list unilever peer0"
  echo -e "\t List channels on 'peer0' of 'Unilever'".
  echo ""

  echo "fablo channel getinfo rantai-pasok-channel petani peer0"
  echo -e "\t Get channel info on 'peer0' of 'Petani'".
  echo ""
  echo "fablo channel fetch config rantai-pasok-channel petani peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'Petani'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> rantai-pasok-channel petani peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'Petani'".
  echo ""

  echo "fablo channel getinfo rantai-pasok-channel koperasi peer0"
  echo -e "\t Get channel info on 'peer0' of 'Koperasi'".
  echo ""
  echo "fablo channel fetch config rantai-pasok-channel koperasi peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'Koperasi'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> rantai-pasok-channel koperasi peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'Koperasi'".
  echo ""

  echo "fablo channel getinfo rantai-pasok-channel pabrikkelapasawit peer0"
  echo -e "\t Get channel info on 'peer0' of 'PabrikKelapaSawit'".
  echo ""
  echo "fablo channel fetch config rantai-pasok-channel pabrikkelapasawit peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'PabrikKelapaSawit'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> rantai-pasok-channel pabrikkelapasawit peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'PabrikKelapaSawit'".
  echo ""

  echo "fablo channel getinfo rantai-pasok-channel unilever peer0"
  echo -e "\t Get channel info on 'peer0' of 'Unilever'".
  echo ""
  echo "fablo channel fetch config rantai-pasok-channel unilever peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'Unilever'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> rantai-pasok-channel unilever peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'Unilever'".
  echo ""

}
