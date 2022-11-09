FROM ubuntu:20.04

# Set the SHELL option -o pipefail before RUN with a pipe in
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Download
# Create an user and a folder
RUN useradd -m actions-runner
RUN mkdir -p /home/actions-runner
WORKDIR /home/actions-runner

# Download the latest runner package
RUN apt-get update && apt-get install -y curl
RUN curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz

# Optional: Validate the hash
# RUN echo "147c14700c6cb997421b9a239c012197f11ea9854cd901ee88ead6fe73a72c74  actions-runner-linux-x64-2.299.1.tar.gz" | shasum -a 256 -c

# Extract the installer
RUN tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz
RUN ./bin/installdependencies.sh

#Configure
# Create the runner and start the configuration experience
# CMD [ "./config.sh", "--url https://github.com/mariocastronovo/acr-build-helloworld-node", "--token ABZU3MR4NPEOPOQSVI6PDOLDNPAW4"]

# Copy out the runsvc.sh script to the root directory for running the service
RUN cp bin/runsvc.sh . && chmod +x ./runsvc.sh

# Last step, run it!
COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh
CMD [ "./entrypoint.sh"]

# Using your self-hosted runner
# Use this YAML in your workflow file for each job
# CMD runs-on: self-hosted
