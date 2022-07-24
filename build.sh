#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

###############################
# Docker images build script
#
###############################

ATF_BASE='atf.solutions.com.br'
ATF_IP='172.20.1.12'
ATF_PORTA='5333'
BINARIOS_BASE='binarios.solutions.com.br'
BINARIOS_IP='172.20.1.121'
PROJECT_NAME=$(jq -r '.repository | ltrimstr("fks/")' image.json)
REPOSITORY=$(jq '.repository' image.json | cut -d'"' -f2)
SCRIPT_NAME=$(basename "$0")
TAG=$(jq '.tag' image.json | cut -d'"' -f2)

echo "[$SCRIPT_NAME] >> Searching for pre-build tests ..."
if [ -x "./tests/prebuild.sh" ]; then
  ./tests/prebuild.sh
else
  echo "[$SCRIPT_NAME] >> tests/prebuild.sh not found. Ignoring pre-build tests."
  echo ''
fi

echo "[$SCRIPT_NAME] >> Validating Dockerfile ..."
docker run --rm -i $ATF_BASE:5001/hadolint/hadolint:v1.23.0 < Dockerfile
echo ''

echo "[$SCRIPT_NAME] >> Building the image ..."
docker build \
       --add-host $ATF_BASE:$ATF_IP \
       --add-host $BINARIOS_BASE:$BINARIOS_IP \
       --network host \
       --rm \
       --tag="$ATF_BASE:$ATF_PORTA/fks/$REPOSITORY:$TAG" \
       -f Dockerfile .
echo ''

echo "[$SCRIPT_NAME] >> Searching for post-build tests ..."
if [ -x "./tests/postbuild.sh" ]; then
  docker run \
         --rm \
         --add-host $ATF_BASE:$ATF_IP \
         --add-host $BINARIOS_BASE:$BINARIOS_IP \
         --network host \
         --volume "$PWD"/tests:/tests \
         --name "$PROJECT_NAME"-postbuild-test \
         --user root \
         "$ATF_BASE:$ATF_PORTA/fks/$REPOSITORY:$TAG" \
         /tests/postbuild.sh
else
  echo ''
  echo "[$SCRIPT_NAME] >> tests/postbuild.sh not found. Ignoring post-build tests."
fi
