# i3c.Cloud

<p align="center">
  <img title="i3c.Cloud" width="155px" height="55px" src="https://raw.githubusercontent.com/virtimus/i3c/master/assets/images/i3c-logo-black.svg?sanitize=true">
</p>

i3c.Cloud is currently my personal R&D platform for quickly prototyping different software artifacts and making try and error experiments.

The Principles are:

- idea storage & reference
- distribute elements as loosly coupled microservices
- easy deploy, sharing & presentation of working solution prototypes

## Quick start:

### Windows



- Use PowerShell from system console to enable WSL (Microsoft Windows Subsystem for Linux) on Your Windows instance:

```bash
PowerShell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
(restart maybe needed)

- run bootstrap for dockerToolbox & WSL from system console: 

```bash
PowerShell Start-BitsTransfer -source https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.bat -destination bootstrap.bat

bootstrap.bat
```
This will install Docker Toolbox & Bash shell for Windows.
When "Setup - Docker Toolbox" window apears - You can just accept defaults.

- run "Bash on Ubuntu on Windows" console - this should check out and install i3c.cloud platform from this github repo.

### Linux

- install Docker
- run main bootstrap script:
```bash
curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.sh | bash
```

## Demo

You can quickly deploy current develop version inside a "play-with-docker" (PWD) playground:

- Browse [PWD/?stack=i3c-install/stack1.yml](http://play-with-docker.com/?stack=https://raw.githubusercontent.com/virtimus/i3c/master/i3c-install/stack1.yml)
- Sign in with your [Docker ID](https://docs.docker.com/docker-id)
- to use i3c shell in PWD run this on main shell:
```bash
docker exec -it i3c /bin/bash
```
- now i3c-cli is accesible.

To run [Portainer](https://github.com/portainer/portainer) for instance build and run image:

```bash
/i rebuild portainer
/i rerun portainer
```

or shorter one:
```bash
/i rbrr portainer
```
Portainer will be available on port 9000 (domain resolution is not working on PWD)

Or node-red:
```bash
/i rbrr nodered
```
Consul
```bash
/i rbrr consul
```

... etc

On standard environment you can easily setup own apps under '/i3c.local/dockerfiles' folder

- Follow [these](https://raw.githubusercontent.com/virtimus/i3c/master/i3c-install/stack1.yml) steps inside stack1.yml.


## Manual installation "from scratch" as full i3c.Cloud platform master node (local/bootstrap)
- For Windows you need first to build a Linux/Docker/Bash environment: 
    - install "Docker Toolbox" and "Bash on Ubuntu on Windows" (lxrun /install /yLinux) 
    - add host connection to bash profile (replacing "virtimus" with Your username and ip of docker host if needed):
    ```bash
    echo "export DOCKER_HOST='tcp://192.168.99.100:2376'" >> ~/.bashrc
    echo "export DOCKER_CERT_PATH='/mnt/c/Users/virtimus/.docker/machine/machines/default'" >> ~/.bashrc
    echo "export DOCKER_TLS_VERIFY=1" >> ~/.bashrc
    ```
    - run VirtualBox and add shared folder to "default" (docker host) machine: 
    c:/i3cRoot -> i3c -> automatic mount, persistent 
    - restart docker toolbox
    
- Next steps are common for Windows/Linux:    
- Make sure there are bash/git/curl/docker installed but no i3c* container is running (docker ps)
- Backup and clean /i3c root dir (or at least make dir /i3c/i3c empty)
- You can create symbolic links for whole /i3c or /i3c/log and /i3c/data subfolders as they can grow big ....
ie (for BUOW):
```bash
ln -s /mnt/c/i3cRoot /i3c
```
- make sure docker is connected/runing (ie docker ps)

- set some optional ENV VARS(export [VARNAME]=[VALUE]):

  - I3C_LOCAL_ENDPOINT - external domain of Your Host (default i3c.h)
  - I3C_UDF_HOME - additional user i3c dockerfiles Home dir, default i3cData/i3c.user (example project i3c-crypto)

- Run main bootstrap script:
```bash
curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.sh | bash
```
- monitor installation progress:

```bash
tail -f /i3c/log/bootstrap.log
```

- at the end You should have containers i3c/i3cp running (docker ps)

- ... and runing backend ui:
```bash
/i rebuild portainer
/i rerun portainer
tail -f /i3c/log/portainer/grunt-run-dev.log ("Waiting..." line means success)
```

- backend portainer UI available at [hostIp]:9000 (localhost:9000 or 192.168.99.100:9000)

## Installation of docker-compose in wsl

```bash
export DOCKER_COMPOSE_VERSION=1.22.0
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
```

For some tools one will need corect timezone:
ssh into dhost
tce-fetch.sh tzdata.tcz
sudo mount tzdata.tcz ext -t squashfs -o loop,ro,bs=4096
export TZ=$(find ext/usr/local/share/zoneinfo -type f -name London | xargs tail -1)
sudo umount ext
rm -rf ext tzdata.tcz

(ie export TZ=CET-1CEST,M3.5.0,M10.5.0/3)

sudo apt-get install git-svn
apt install ant
apt-get install net-tools openjdk-8-jdk ant ant-optional

PermitRoot yes
sudo /usr/local/etc/init.d/openssh restart
ln -s /usr/local/etc/ssh/ssh_host_rsa_key /usr/local/etc/ssh/ssh_host_ed25519_key


## Installation as local i3c.Cloud endpoint
... to be done
### Windows
...
### Linux
...
### Android
...
============================

## TODO

- nicer/smaller appDefs (ie openremote\openremote\proxy\Dockerfile)
