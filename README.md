# arm-m-dev

ARM M processors family docker-based development environment example

## Prerequisites

The folder containing the *Dockerfile* should contain the
[J-Link Software and Documentation Pack](https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack)
and [Ozone - The J-Link Debugger](https://www.segger.com/downloads/jlink/#Ozone)
*deb* packages in order enabling debugging functionality.

## Compilation

Run

```bash
docker image build \
--build-arg USER_ID=$(id -u ${USER}) \
--build-arg GROUP_ID=$(id -g ${USER}) \
--build-arg USER_NAME=${USER} \
--build-arg GROUP_NAME=${USER} \
-t arm-m-dev \
.
```

## Installation

Run `docker run --rm -v "$HOME/.local/bin:/home/user/.local/bin" arm-m-dev
install.sh` to install development environment into the `~/.local/bin` folder.

## Project initialization

Run `arm-m-dev-create.sh <proj_name>` inside project folder. This will
initialize environment for this project.

## More info

For more information visit the
[DDEN](https://hub.docker.com/repository/docker/psugrg/dden/general)
project page.
