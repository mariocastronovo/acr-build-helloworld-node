#!/usr/bin/env bash

function error {
    echo "Error; $1"
}

echo "Configuring GitHub Actions Runner and registering"
./config.sh \
    --unattended \
    --url "https://github.com/mariocastronovo/acr-build-helloworld-node" \
    --token "ABZU3MR4NPEOPOQSVI6PDOLDNPAW4" \
    --name "mcstestrunner" \
    $OPTIONS

echo "Starting GitHub Actions Runner"
env -i ./runsvc.sh
