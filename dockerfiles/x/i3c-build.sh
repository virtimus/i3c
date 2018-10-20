

#clone 
_cloneOrPull https://github.com/jessfraz/dockerfiles.git  jessfraz_dockerfiles

echo "[i3c-build] Building from x-lib with args: $@ ..."

REGISTRY=r.j3ss.co

cd $uData/jessfraz_dockerfiles
export DIR=$3
make image
/i -v tag $REGISTRY/${DIR/\//:} i3c/x/$DIR
/i -v tag $REGISTRY/${DIR/\//:} i3c/x/$DIR:$i3cVersion 
doCommand=false;