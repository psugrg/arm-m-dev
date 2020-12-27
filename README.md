# arm-m-dev

ARM M processors family docker-based development environment example.
It's based on the [DDEN](https://hub.docker.com/repository/docker/psugrg/dden/general)
infrastructure wchich means that it derives from DDEN and it expects to be
derived by the [DUSET](https://github.com/psugrg/duset) in order to create
an image with local user rights for installation.

## Prerequisites

The folder containing the *Dockerfile* should contain the
[J-Link Software and Documentation Pack](https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack)
and [Ozone - The J-Link Debugger](https://www.segger.com/downloads/jlink/#Ozone)
*deb* packages in order enabling debugging functionality.

## Compilation

```bash
docker image build \
--build-arg USER_ID=$(id -u ${USER}) \
--build-arg GROUP_ID=$(id -g ${USER}) \
--build-arg USER_NAME=${USER} \
--build-arg GROUP_NAME=${USER} \
-t arm-m-dev \
.
```

## Deployment

Compiled image can be stored in `docker registry` or `docker hub` where it
can be accessed by developers who want to install it via the DUSET image.
