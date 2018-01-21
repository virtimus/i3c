# i3c.Cloud

<p align="center">
  <img title="i3c.Cloud" width="155px" height="55px" src="https://raw.githubusercontent.com/virtimus/i3c/master/assets/images/i3c-logo-black.svg?sanitize=true">
</p>

i3c.Cloud is currently my personal R&D platform for quickly prototyping different software artifacts and making try and error experiments.

The Principles are:

- idea storage & reference
- distribute elements as loosly coupled microservices
- easy deploy, sharing & presentation of working solution prototypes

## Demo

You can quickly deploy current develop version inside a "play-with-docker" (PWD) playground:

- Browse [PWD/?stack=i3c-install/stack5.yml](http://play-with-docker.com/?stack=https://raw.githubusercontent.com/virtimus/i3c/develop/i3c-install/stack5.yml)
- Sign in with your [Docker ID](https://docs.docker.com/docker-id)
- Follow [these](https://raw.githubusercontent.com/virtimus/i3c/develop/i3c-install/stack5.yml) steps inside stack5.yml.


## Installation "from scratch" as full i3c.Cloud platform master node (local/bootstrap)
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


## Installation as local i3c.Cloud endpoint
... to be done
### Windows
...
### Linux
...
### Android
...
============================
