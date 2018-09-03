
* [_echo()](#_echo)
* [_setverbose()](#_setverbose)
* [_autoconf()](#_autoconf)
* [load()](#load)
* [save()](#save)
* [savez()](#savez)
* [_procVars()](#_procVars)
* [_imageClonePullForBuild()](#_imageClonePullForBuild)
* [cloneDfAndBuild()](#cloneDfAndBuild)
* [cloneUdfAndRun()](#cloneUdfAndRun)
* [up()](#up)
* [build()](#build)
* [_build()](#_build)
* [_checkRunning()](#_checkRunning)
* [crun()](#crun)
* [run()](#run)
* [_rm()](#_rm)
* [psa()](#psa)
* [_ps()](#_ps)
* [rmidangling()](#rmidangling)
* [start()](#start)
* [stop()](#stop)
* [pid()](#pid)
* [ip()](#ip)
* [logs()](#logs)
* [exsh()](#exsh)
* [exshd()](#exshd)
* [exec()](#exec)
* [execd()](#execd)
* [tag()](#tag)
* [images()](#images)
* [rebuild()](#rebuild)
* [rerun()](#rerun)
* [cert()](#cert)
* [winit()](#winit)
* [_cp()](#_cp)
* [images()](#images)


## _echo()

echo encapsulation
### Arguments

* noarg

## _setverbose()

set -x  encapsulation
### Arguments

* noarg

## _autoconf()

autoconfigure i3c user home dir
 (currently only if imagedef folder exists

### Arguments

* **$1** (-): operation (create/readUHome/read/store)
* **$2** (-): folder
* **$3** (-): [optional] subfolder

## load()

load an image stored in imagedef dir into local docker repo 
### Arguments

* **$1** (-): image to load (appName)

## save()

save an image from local repo into imagedef dir (.i3ci)
### Arguments

* **$1** (-): appdef to save

## savez()

save an image from local repo into imagedef dir as zipped (.i3czi)
### Arguments

* **$1** (-): appdef to save

## _procVars()

processing different i3c platform config files 
(normally process 'i3c-[command].sh' files according to current priorities
### Arguments

* **...** (-some): args for taget script

## _imageClonePullForBuild()

given an git repo and folder take docker imagedef for later build and pull to local repo
!todo - option -b for automatic build and use from /i level (requires extractind _buildint from build)

### Arguments

* **$1** (repo): url (ie https://github.com/swagger-api)
* **$2** (folder): name inside the repo

#### Example

```bash
used ie in i3c-build.sh scripts:
i3c-openapi/swagger-editor
```

## cloneDfAndBuild()

clone given 3d party repo

### Arguments

* **$1** (repo): path
* **$2** (dockerfile): folder inside this repo (the path will be available in container under /i3c/data)
* **$3** (image/container): name to buil
* **$4** (optional): arg for image name if different than appName 

## cloneUdfAndRun()

clone a workspace from git, build and run given git repo, imagedef/app name and also name of container to run
### Arguments

* **$1** (repo): path (ie https://github.com/virtimus 
* **$2** (repo): name (ie i3c-openapi)
* **$3** (imagedef/containder): name (ie swagger-editor)

#### Example

```bash
 /i clur https://github.com/virtimus i3c-openapi swagger-editor
```

## up()

up with composer (if file present)
### Arguments

* **$1** (appDef):

## build()

build with docker
### Arguments

* **$1** (-): appDef

## _build()

internal build part
### Arguments

* **$1** (-): appDef

## _checkRunning()

scheck if running
### Arguments

* **$1** (-): appDef

## crun()

check if runing and run
### Arguments

* **$1** (-): appDef

## run()

run given container by name
### Arguments

* **$1** (-): appDef 

## _rm()

remove container by name
### Arguments

* **$1** (-): appDef

## psa()

list runing containers
## _ps()

list all containers
## rmidangling()

remove all dangling images
## start()

start stopped container
### Arguments

* **$1** (-): appDef

## stop()

stop runing container
### Arguments

* **$1** (-): appDef

## pid()

pid
### Arguments

* **$1** (-): appDef

## ip()

ip
### Arguments

* **$1** (-): appDef

## logs()

logs
### Arguments

* **$1** (-): appDef

## exsh()

run command on container using sh -it
### Arguments

* **$1** (-): appDef
* ${@:2} - command(s)

## exshd()

run command on container using sh non-interactive
### Arguments

* **$1** (-): appDef
* ${@:2} - command(s)

## exec()

run command on container -it
### Arguments

* **$1** (-): appDef
* ${@:2} - command(s)

## execd()

run command on container non-interactive
### Arguments

* **$1** (-): appDef
* ${@:2} - command(s)

## tag()

tag a container
### Arguments

* **$1** (-): appDef
* ${@:2} - rest of args

## images()

list images !todo
## rebuild()

stop, remove and build container by name
### Arguments

* **$1** (-): appDef

## rerun()

stop, remove and run container by name
### Arguments

* **$1** (-): appDef

## cert()

get new certificate for given subdomain(ie container name)
currently using certbot/letsgetencrypt
### Arguments

* **$1** (-): appDef

## winit()

initialize new user workspace in current folder, no args needed
## _cp()

cp into or from container
### Arguments

* **...** (-): same as docker cp

## images()

list images
### Arguments

* **...** (-): same as docker images	

