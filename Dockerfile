FROM node:15-alpine

COPY . /src
RUN cd /src && npm install
EXPOSE 80
CMD ["node", "/src/server.js"]

# Download
# Create a folder
$ mkdir actions-runner && cd actions-runner# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz# Optional: Validate the hash
$ echo "147c14700c6cb997421b9a239c012197f11ea9854cd901ee88ead6fe73a72c74  actions-runner-linux-x64-2.299.1.tar.gz" | shasum -a 256 -c# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz

#Configure
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/mariocastronovo/acr-build-helloworld-node --token ABZU3MTMYH2XI7PHVQMUASTDNN5OS# Last step, run it!
$ ./run.sh

# Using your self-hosted runner
# Use this YAML in your workflow file for each job
runs-on: self-hosted
