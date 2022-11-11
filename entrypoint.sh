#!/usr/bin/env bash

set -eEo pipefail

function error {
    echo "Error; $1"
}

OPTIONS="${RUNNER_OPTIONS:-""}"


function getRegistrationToken {
    if [[ -z GITHUB_TOKEN ]]; then
        error "A GITHUB_TOKEN environment variable is required to register the actions runner with the repository or organization."
        exit 1
    else
        # Get a short lived token to register the actions runner
        echo "Getting registration token for runner..."

        if [[ -z $SCOPE ]]; then
            error "Was not able to identify SCOPE for the token"
            exit 1
        fi

        if [[ ${SCOPE} == "enterprises" ]]; then
            URL_PATH="$(echo "${RUNNER_URL}" | grep / | cut -d/ -f5-)"
        else
            # Get the path to the organization or repository
            URL_PATH="$(echo "${RUNNER_URL}" | grep / | cut -d/ -f4-)"
        fi
        TOKEN_URL="${API_BASE}/${SCOPE}/${URL_PATH}/actions/runners/registration-token"
        echo "Getting Actions runner registration token from ${TOKEN_URL}"
        TOKEN="$(curl -X POST -fsSL -H "Authorization: token ${GITHUB_TOKEN}" ${TOKEN_URL} | jq -r .token)"
    fi
}

SCOPE=""
TOKEN=""

if [[ -z $GITHUB_SERVER ]]; then
    export API_BASE=https://api.github.com
else
    export API_BASE="${GITHUB_SERVER}/api/v3"
fi
echo "Using ${API_BASE} as Base URL"

if [[ -z $RUNNER_NAME ]]; then
    echo "Using hostname for Actions Runner Name."
    export RUNNER_NAME=${HOSTNAME}
fi

RUNNER_URL=${RUNNER_REPOSITORY_URL}
SCOPE=repos

OPTIONS="${RUNNER_OPTIONS:-""}"
# If the user has provided any runner labels add them to the config options
if [[ -n ${RUNNER_LABELS} ]]; then
    OPTIONS="${OPTIONS} --labels ${RUNNER_LABELS}"
fi

GROUP=${RUNNER_GROUP:-"default"}

echo "Getting temporary access token for registering"
getRegistrationToken

echo "Configuring GitHub Actions Runner and registering"
./config.sh \
    --unattended \
    --url "$RUNNER_REPOSITORY_URL" \
    --token "${TOKEN}" \
    --name "${RUNNER_NAME}" \
    --runnergroup ${GROUP} \
    $OPTIONS

echo "Starting GitHub Actions Runner"
env -i ./runsvc.sh

# Deregister
echo Cleaning up runner registration...
getRegistrationToken
./config.sh remove --token "${TOKEN}"
