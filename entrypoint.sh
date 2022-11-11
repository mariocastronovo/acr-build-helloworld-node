#!/usr/bin/env bash

function error {
    echo "Error; $1"
}

OPTIONS="${RUNNER_OPTIONS:-""}"

GROUP=${RUNNER_GROUP:-"default"}

echo "Configuring GitHub Actions Runner and registering"
./config.sh \
    --unattended \
    --url "https://github.com/mariocastronovo/acr-build-helloworld-node" \
    --token "ABZU3MQAUTN3S257PEMZN6LDNY3DC" \
    --name "mcstestrunnernew" \
    --runnergroup ${GROUP} \
    $OPTIONS

echo "Starting GitHub Actions Runner"
env -i ./runsvc.sh

