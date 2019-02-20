# Workspace #
[![Build Status](https://travis-ci.org/ashenm/workspace.svg?branch=master)](https://travis-ci.org/ashenm/workspace) [![Image Overview](https://images.microbadger.com/badges/image/ashenm/workspace.svg)](https://hub.docker.com/r/ashenm/workspace/)

## INDEX ##

* [Usage](#usage)
  * [Using `scripts/run.sh`](#using-scriptsrunsh)
    * [Directory Mounts](#directory-mounts)
    * [Git Configuration](#git-configuration)
    * [SSH Configuration](#ssh-configuration)
    * [Working Directory](#working-directory)
    * [Custom Shell](#custom-shell)
    * [Custom Image](#custom-image)
  * [Using `docker run`](#using-docker-run)
* [Compatibility](#compatibility)
  * [Windows](#windows)
    * [UNIX Permissions](#unix-permissions)
  * [`scripts`](#scripts)

## USAGE ##

### Using `scripts/run.sh` ###

#### Directory Mounts ####
###### `-m` `-v` `--mount` `--volume` ######

The option `-m` or `--mount` can be used to bind mount a host directory to a new container either using a relative or an absolute path. It will be binded at `~/workspace` on the created container.

For instance, to bind current directory run `./run.sh --m .` or `./run.sh --mount .`.

Similarly, to bind a directory like `C:\foo\bar` using an absolute path on a Windows[**\***](#compatibility) system to container's `~/workspace` run `./run.sh -m  C:\foo\bar`.

Additional volumes can be binded using multiple `-v` or `--volume` followed by respective source and destination path in standard docker format.

For instance, to bind mount directory `C:\foo\bar` at `/mnt/foo/bar` with read-only permissions run `./run.sh -v C:\foo\bar:/mnt/foo/bar:ro`.

#### Git Configuration ####
###### `--git` ######

The present of flag `--git` will bind `~/.gitconfig` on host to `~/.gitconfig` on  the container with read-only access.

#### SSH Configuration ####
###### `--ssh` ######

The present of flag `--ssh` will bind `~/.ssh` on host to `~/.ssh` on container with read-only access.

#### Working Directory ####
###### `-w` `--workdir` ######

The default working directory of the container is set to `~/workspace`. It can be overridden to suit the need by using either `-w` or `--workdir` followed by the absolute path of the desired directory.

For instance, to set `/usr/share/workspace` as the container working directory run `./run.sh -w /usr/share/workspace`.

#### Custom Shell ####
###### `--shell` ######

By default `run.sh` will attempt to spawn a `bash` login shell. If a custom installed shell is desired add `--shell` followed by the shell executable.

For instance, to use _KornShell_ instead run `./run.sh --shell ksh`.

#### Custom Image ####

The `run.sh` can be used to run any docker image that is not intended to be run as an executable. By default, it will attempt to use [ashenm/workspace:latest](https://hub.docker.com/r/ashenm/workspace) as the image unless specified.

The default image can be overridden by simply specifying the desired image name. If multiple images are specified the last most image name will be used.

For instance, to bind current directory within `alpine:latest` run `./run.sh -m . alpine:latest`.

### Using `docker run` ###

Please refer [Official Docker Documentation](https://docs.docker.com/engine/reference/commandline/run)

## COMPATIBILITY ##

### Windows ###
#### UNIX Permissions ####

The Docker Desktop currently uses SMB/CIFS for host volumes and therefore does not support multiple users nor different file permissions on host mounts.

A mundane solution would be to use _[Docker Volumes](https://docs.docker.com/storage/volumes/)_ which are independent of the directory structure of the host machine. The `workspace/workspace.cmd` facilitate ease administration of Docker Volumes allowing [creation](#workspace-create), [backup](#workspace-backup), [upload](#workspace-push), and [deletion](#workspace-delete).

###### `workspace create`  ######

Creates a new Docker Volume named _workspace_ that containers can consume and store data in.

###### `workspace backup` ######

Creates a gzip tarball in the current working directory from the files stored in Docker Volume _workspace_.

###### `workspace push` ######

Clones current working directory into the Docker Volume _workspace_.

###### `workspace delete` ######

Remove Docker Volume _workspace_.

### `scripts` ###

Given that _[Docker](https://www.docker.com/)_ is installed, the facilitator scripts provided can be used with any shell that is is *Bourne SHell* compatible.

For _Microsoft Windows_ use a POSIX-compliant run-time environment such as _MSYS_ or _Cygwin_ with _[WinPTY](https://github.com/rprichard/winpty
)_ or Microsoft's own [_Windows Subsystem for Linux_](https://docs.microsoft.com/en-us/windows/wsl/about).
