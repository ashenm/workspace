#!/usr/bin/env sh
# Run a workspace in a new container

set -e

#######################################
# Print usage instructions to STDIN
# Arguments:
#   None
# Returns:
#   None
#######################################
usage() {

cat <<USAGE

Usage: $SELF [OPTIONS] [IMAGE]
Run a workspace in a new container

Options:
      --dev                 Use "dev" tag instead of "latest"
      --dry                 Automatically remove the container when it exits
      --help                Print usage
  -h, --hostname string     Container hostname
      --git                 Bind mount ~/.gitconfig read-only to container
  -m, --mount path          Bind mount specified directory to workspace
  -n, --name                Assign a name to the container
  -p, --publish             Publish container's 8080, 8081 and 8082 ports to the host
      --shell               Specify login shell (default 'bash')
      --ssh                 Bind mount ~/.ssh directory read-only to container
  -v, --volume              Bind mount additional volumes
  -w, --workdir             Working directory inside the container

USAGE

}

#######################################
# Print invalid argument details to STDERR
# Arguments:
#   Invalid argument
# Returns:
#   None
#######################################
invalid() {

cat >&2 <<INVALID

$SELF: unrecognized option '$1'
Try '$SELF --help' for more information.

INVALID

}

# script reference
SELF="$(basename "$0")"

# docker options
ARGUMENTS="--interactive --tty"

# command to run
CONTAINER_CMD="bash"
CONTAINER_CMD_OPTIONS="-l"

# docker command supplementaries
COMMAND_PREFIX=""
CONTAINER_IMAGE_TAG="latest"

# parse options
while [ $# -ne 0 ]
do

  case "$1" in

    --help)
      usage
      exit 0
      ;;

    --dry)
      ARGUMENTS="$ARGUMENTS --rm"
      shift
      ;;

    --ssh)
      ARGUMENTS="$ARGUMENTS --volume $(readlink -m ~/.ssh):/home/ubuntu/.ssh:ro"
      shift
      ;;

    --git)
      ARGUMENTS="$ARGUMENTS --volume $(readlink -m ~/.gitconfig):/home/ubuntu/.gitconfig"
      shift
      ;;

    -p|--publish)
      ARGUMENTS="$ARGUMENTS --publish 8080:8080 --publish 8081:8081 --publish 8082:8082"
      shift
      ;;

    -h|--hostname)
      ARGUMENTS="$ARGUMENTS --hostname ${2:?Invalid HOSTNAME}"
      shift 2
      ;;

    -w|--workdir)
      ARGUMENTS="$ARGUMENTS --workdir ${2:?Invalid WORKDIR}"
      shift 2
      ;;

    -v|--volume)
      ARGUMENTS="$ARGUMENTS --volume ${2:?Invalid BIND}"
      shift 2
      ;;

    -n|--name)
      ARGUMENTS="$ARGUMENTS --name ${2:?Invalid NAME}"
      shift 2
      ;;

    -m|--mount)
      CONTAINER_MOUNT="${2:?Invalid VOLUME}"
      shift 2
      ;;

    --shell)
      CONTAINER_CMD="${2:?Invalid SHELL}"
      shift 2
      ;;

    --dev)
      CONTAINER_IMAGE_TAG="dev"
      shift
      ;;

    -*|--*)
      invalid "$1"
      exit 1
      ;;

    *)
      CONTAINER_IMAGE_NAME="$1"
      shift
      ;;

  esac

done

# expand absolute path and append
# if directory bind mount specified
test "$CONTAINER_MOUNT" && \
  ARGUMENTS="$ARGUMENTS --volume $(readlink -m $CONTAINER_MOUNT):/home/ubuntu/workspace"

# handle windows terminal
# emulators Cygwin, MSYS, ...
test "$OS" = "Windows_NT" && \
  COMMAND_PREFIX="$COMMAND_PREFIX winpty"

# build :dev image
# if not exists locally
test "$CONTAINER_IMAGE_TAG" = "dev" -a \
  "$(docker images ashenm/workspace:dev | tail -n +2 | wc -c)" -eq 0 && \
    "$(dirname "$(readlink -f "$BASH_SOURCE")")"/build.sh

# override default image
# if explicitly specified
ARGUMENTS="$ARGUMENTS ${CONTAINER_IMAGE_NAME:-ashenm/workspace}:${CONTAINER_IMAGE_TAG}"

# spin docker container
$COMMAND_PREFIX docker run $ARGUMENTS $CONTAINER_CMD $CONTAINER_CMD_OPTIONS

